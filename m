Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C52FD33C457
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 18:36:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231441AbhCORfa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 13:35:30 -0400
Received: from mail-pj1-f46.google.com ([209.85.216.46]:41901 "EHLO
        mail-pj1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232763AbhCORfP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Mar 2021 13:35:15 -0400
Received: by mail-pj1-f46.google.com with SMTP id nh23-20020a17090b3657b02900c0d5e235a8so15185003pjb.0
        for <stable@vger.kernel.org>; Mon, 15 Mar 2021 10:35:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=20JfwgWAj5jIH3Zv2+rX77p4EFNS+TT7biWNv73++2E=;
        b=Uk3yJfMtAHRQV/oH3w5XXYWcD00gu3jm6J6QUK62aVTVTPdJWgbXeZZ18uwBE4FBkg
         XGLfD3bzBHUfVp90LX+fkSwtwr2xS58qvL6qRWrmn4/acntk6xT4JmVxm0+LZ8SQefjr
         QPRlcX/AfeGQxac98a8pP1I/65VbkJADkR1kQlzY8wniaIlqjf1SvNPFQny2qNtRLtmt
         2ZQnwqVWdmC72jvSG2yR/Kx46rI8U2hD+4aRr65IIzR2RkezcUeAy8D0a4pMbkdfYPPj
         MYcpmX6TMAjJc2O/ro/PPhwjbNIsaITL4fx7gukLlMot/JrQh/8fLIdPnSwT2xewrVGE
         2gtQ==
X-Gm-Message-State: AOAM532D2k+fuZllmu3pUD/Igq2+LFEZh0M3OqlNKyE3Vv5OsM64bgxu
        /DgCZcKGnDcvMijxVuKj3Ps=
X-Google-Smtp-Source: ABdhPJyUVdFwxUSODtafOcajsXBRec0eXxrYBGBsDH7b4x9oxoh17J/1Wqw9yv60YXJPo+s9tyuZOQ==
X-Received: by 2002:a17:90b:3692:: with SMTP id mj18mr209536pjb.44.1615829714932;
        Mon, 15 Mar 2021 10:35:14 -0700 (PDT)
Received: from ?IPv6:2601:647:4802:9070:4faf:1598:b15b:7e86? ([2601:647:4802:9070:4faf:1598:b15b:7e86])
        by smtp.gmail.com with ESMTPSA id t19sm13686115pgj.8.2021.03.15.10.35.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Mar 2021 10:35:14 -0700 (PDT)
Subject: Re: nvme: ns_head vs namespace mismatch fixes
To:     Greg KH <gregkh@linuxfoundation.org>,
        Anton Eidelman <anton@lightbitslabs.com>
Cc:     stable@vger.kernel.org, kbusch@kernel.org, hch@lst.de
References: <20210314040705.1357858-1-anton@lightbitslabs.com>
 <YE25OKl9g+cyl3iy@kroah.com>
From:   Sagi Grimberg <sagi@grimberg.me>
Message-ID: <f2c97512-ac31-b45d-34b9-926248cc0a28@grimberg.me>
Date:   Mon, 15 Mar 2021 10:35:13 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <YE25OKl9g+cyl3iy@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


> This text is not compatible with kernel development in public, email is
> now deleted.

Sorry for that Greg, this was an oversight as this is an auto-added
footer to the corporate email... obviously not the intention here.
