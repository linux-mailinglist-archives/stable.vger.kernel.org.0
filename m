Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39B5E40DB70
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 15:39:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240255AbhIPNkl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 09:40:41 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:35125 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240091AbhIPNkk (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Sep 2021 09:40:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631799560;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SlssuObY3unbQXdzRBNc69srM/t/JJD/INbJ4v1Ek6A=;
        b=d9gWSBEmThRq+vE+FJ+iQYgNTYGqmDu7k4N4w4D9YyRXBWkKUIXX1x+yna3iN/EKexOBDy
        tzAWZbHsvbHU1ZsRdanOcLpbDVUcZ9K/H6qkr3gaRILQf060PQODuymu+wN19Tr4A22GHg
        YFvcKn9BGXHFhK+RkB5h20Oow7OEGfI=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-488-yMwQFEJRMNmbR2Ii5kp5QA-1; Thu, 16 Sep 2021 09:39:18 -0400
X-MC-Unique: yMwQFEJRMNmbR2Ii5kp5QA-1
Received: by mail-wr1-f72.google.com with SMTP id v15-20020adff68f000000b0015df51efa18so2432914wrp.16
        for <stable@vger.kernel.org>; Thu, 16 Sep 2021 06:39:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=SlssuObY3unbQXdzRBNc69srM/t/JJD/INbJ4v1Ek6A=;
        b=Ut2aaR0V0xob3Z537g2HyPZBl/JiMsM7WOg9zc0KZIgLeDaobEKe5K3FDRRX1kSi2T
         gBw5iVAdd8ihp8twuN0QUERT08lQX+dh9oaE/bYJmrkrbirefTT2QfXav5gAvRlu4g9y
         5O8LVqz+O3k/GokKQfTLd/4QgXG+EoZi30/XnDF/FeMttEw5jWXMiNtLw19Z4sZpMMS5
         PQQqU1scO70ysk8BkWvr8pudt6Q+V82aWNIkqWxLhqwDRQZXIW/NetsbVnlkCaxw9wlv
         Vq87SBz6QXLbNwtRU6fQsLe87WfHMLPFDMLIg7vPXiQGSe9fJi2q/Y/rnPr02tPXgbJm
         vzSQ==
X-Gm-Message-State: AOAM530FBju+kJ/ZZ39VoZ+nXnG8A7pr/TSmkbz0h2lTVvA5/XYCwgh5
        iLfHdlGtrYupHj2GtjGjzgNPNmppgbLI+clAGUxprNYOQ//A25RRC/yqSqjnEu4oJa64gAZC7Pw
        t3fMhbmnv3eXNrMEI
X-Received: by 2002:a1c:1b48:: with SMTP id b69mr9927391wmb.14.1631799557723;
        Thu, 16 Sep 2021 06:39:17 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxIRt3soPmUXjGo9EKCCkCEejblCbE2Hc/JsP39yc5YAw0slEYwvMjZjOl7A3LWSj9iinP1PQ==
X-Received: by 2002:a1c:1b48:: with SMTP id b69mr9927372wmb.14.1631799557526;
        Thu, 16 Sep 2021 06:39:17 -0700 (PDT)
Received: from ?IPV6:2a02:1205:5026:3180:7cea:b72b:7e73:8d8? ([2a02:1205:5026:3180:7cea:b72b:7e73:8d8])
        by smtp.gmail.com with ESMTPSA id j98sm3578788wrj.88.2021.09.16.06.39.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Sep 2021 06:39:17 -0700 (PDT)
Message-ID: <7fe8e175-efdc-b7d9-ab86-44aeec60c2e9@redhat.com>
Date:   Thu, 16 Sep 2021 15:39:16 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: FAILED: patch "[PATCH] drm/amdgpu: Cancel delayed work when
 GFXOFF is disabled" failed to apply to 5.14-stable tree
Content-Language: en-CA
To:     gregkh@linuxfoundation.org, alexander.deucher@amd.com,
        christian.koenig@amd.com, evan.quan@amd.com, lijo.lazar@amd.com
Cc:     stable@vger.kernel.org
References: <163179752354221@kroah.com>
From:   =?UTF-8?Q?Michel_D=c3=a4nzer?= <mdaenzer@redhat.com>
In-Reply-To: <163179752354221@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2021-09-16 15:05, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 5.14-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

It's already in 5.14, commit 32bc8f8373d2d6a681c96e4b25dca60d4d1c6016.

Please do backport it to older stable trees.


-- 
Earthling Michel Dänzer               |               https://redhat.com
Libre software enthusiast             |             Mesa and X developer

