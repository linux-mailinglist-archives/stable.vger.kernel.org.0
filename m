Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D7C4510C0A4
	for <lists+stable@lfdr.de>; Thu, 28 Nov 2019 00:33:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727116AbfK0XdS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 18:33:18 -0500
Received: from mail-il1-f196.google.com ([209.85.166.196]:34032 "EHLO
        mail-il1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727051AbfK0XdS (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Nov 2019 18:33:18 -0500
Received: by mail-il1-f196.google.com with SMTP id p6so22616093ilp.1
        for <stable@vger.kernel.org>; Wed, 27 Nov 2019 15:33:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=o43agzngz2vxno73kXhyJAfrgkpRc05m9F7s9vii5pY=;
        b=Ymql5KU+7BX4S16qS3L3BaQQpbdGcD1IxZClly/jEKFQOxOqh31sgLq9QdTp3rA2+Z
         3+HZR2TATW81fVxWZo/hVMqhCgyFjLAUhCzX6DzHFB2DzO1xwCKmQ+QZilRff2InK+Ya
         6RhgWpTHJD+bRzO0gP51dQOz/Gtaym305Nx3g=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=o43agzngz2vxno73kXhyJAfrgkpRc05m9F7s9vii5pY=;
        b=lBJxpAEBIB+9zvkLMSfhfbu1FWeqvQxNPjB7SIfL9flYNHZ/vb0RCE/LU5/gMQ/uVG
         kTw9Ustknz/MwBVhBWE0dP92nLLuqmocLFCHkB6Ee24LHNtHUz8mwjUwn6oAdGdy/5Kj
         LUTMKwkoqELp1gN7Q1j2GjZjSFVTspcl6GbgnpC47GmrPbREfwxpWTMzXJM1dWaUKeUY
         AzXtGghWGpclaqi1C2faOIQT6/klwNTb2mkFB30DJTSX2/ncEE1iDBrwOD/KLD0fVcvQ
         OgKb0HFyhEuwc7lDI+SXLSUV3chCJzcrUDH8n83jbv5CC+cPviL8NPn7yaAVvn8wFVrp
         snLw==
X-Gm-Message-State: APjAAAWgwZd8lq2oe/vtZa0Id1B5MiQw7YeVAeayWpkZwuTsmjwk1sF/
        24anK+06069cDv7Kzfu3HYxmoA==
X-Google-Smtp-Source: APXvYqwhDUv1KBRLt+GlRTkytUyW3iTeZv0LMdRgUbQ2lXwqHlLk6yWSsjUhrMzKIBCFhroKVd856w==
X-Received: by 2002:a92:8404:: with SMTP id l4mr50253258ild.137.1574897597447;
        Wed, 27 Nov 2019 15:33:17 -0800 (PST)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id k19sm4102661ion.81.2019.11.27.15.33.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Nov 2019 15:33:16 -0800 (PST)
Subject: Re: FAILED: patch "[PATCH] usbip: Fix uninitialized symbol 'nents'
 in" failed to apply to 4.4-stable tree
To:     gregkh@linuxfoundation.org, suwan.kim027@gmail.com,
        dan.carpenter@oracle.com, lkp@intel.com, stable@vger.kernel.org,
        "skh >> Shuah Khan" <skhan@linuxfoundation.org>
References: <157488438219127@kroah.com>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <2087e46b-34dd-2a68-842a-13091ad66153@linuxfoundation.org>
Date:   Wed, 27 Nov 2019 16:33:15 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.1
MIME-Version: 1.0
In-Reply-To: <157488438219127@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/27/19 12:53 PM, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 4.4-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.
> 
This patch isn't applicable to 4.4 and 4.9. We can ignore the failure.

thanks,
-- Shuah
