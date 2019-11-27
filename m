Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A79F310C0A3
	for <lists+stable@lfdr.de>; Thu, 28 Nov 2019 00:32:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727090AbfK0Xcm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 18:32:42 -0500
Received: from mail-io1-f68.google.com ([209.85.166.68]:36569 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727051AbfK0Xcl (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Nov 2019 18:32:41 -0500
Received: by mail-io1-f68.google.com with SMTP id l17so643876ioj.3
        for <stable@vger.kernel.org>; Wed, 27 Nov 2019 15:32:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=ctUdFzjrZxYI7qrRmjj+IN+YeBmxQDNWCT8koV4HaaY=;
        b=cIP1yyxUAps314BIBRr2f+RUlcToRey67RhedSMaoXal8szQz0ic7So08gr8tgfCE0
         otdPWT1vVnfnzRpCKqX420fXFqhViRx+X8KA50Ripins0sn23h7J6P06s9dSxfmiSkOq
         wRwv1Z3KRRU9dGsClPWmhDf/9QukcCN7Kbz7k=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ctUdFzjrZxYI7qrRmjj+IN+YeBmxQDNWCT8koV4HaaY=;
        b=c5de6EYDd0e3ZwhU/uJ8xNrWvqzq4KMWWFhEGOb6RQh4IafGvM5K8rrC3a5B1LMX/n
         p0Qk5F+V8SSgJpf4g4aYWeCDAAHfjg8hNqKEn1VSjEUp6g+lvoYPCtEG4gbEU0aAmrZB
         5sdFJ96BfFbEQSu1tb8PstN2TQ+Ia8PMIxkHU6qXzCBf3V7T4+r0BRMWORWeVFr+5lNh
         td1OHK9qheaNsH31DqL1+Aag3jws2cwQP5/gRBoWJ4GbSa8GlvaLNT6Qm1xrityqJ89B
         8C+CDVvzkx9XP5oGmGHbvabV76V23ZqQWhJ6K4HKhaSz4scsIvH/MhQsjqqqjcSTnqAl
         s6lw==
X-Gm-Message-State: APjAAAUPADbmzMEy/bjVnq46YkI0PEr9TcTenHf7V3G3tyxz5Oc+OG+9
        9WVTgSm+DfFiNNU8zbHnOsyY0Q==
X-Google-Smtp-Source: APXvYqx/Aszj3bcE0Lrsowydm8GOLz88qNZWUKvkfU4sLQAmtHlM+Pt/NLYr/JzcZ3qKTucN/1zG1Q==
X-Received: by 2002:a6b:f306:: with SMTP id m6mr7597252ioh.172.1574897560913;
        Wed, 27 Nov 2019 15:32:40 -0800 (PST)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id q62sm852302ili.55.2019.11.27.15.32.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Nov 2019 15:32:39 -0800 (PST)
Subject: Re: FAILED: patch "[PATCH] usbip: Fix uninitialized symbol 'nents'
 in" failed to apply to 4.9-stable tree
To:     gregkh@linuxfoundation.org, suwan.kim027@gmail.com,
        dan.carpenter@oracle.com, lkp@intel.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <1574884381220214@kroah.com>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <b3cb8295-cbb3-013c-dc75-1e56ddd0a8de@linuxfoundation.org>
Date:   Wed, 27 Nov 2019 16:32:38 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.1
MIME-Version: 1.0
In-Reply-To: <1574884381220214@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/27/19 12:53 PM, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 4.9-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.
> 

This patch isn't applicable to 4.4. We can ignore the failure.

thanks,
-- Shuah
