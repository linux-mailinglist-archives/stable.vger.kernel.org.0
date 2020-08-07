Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5716223EEF3
	for <lists+stable@lfdr.de>; Fri,  7 Aug 2020 16:20:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726066AbgHGOU1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Aug 2020 10:20:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725815AbgHGOU1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 7 Aug 2020 10:20:27 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C9F7C061756
        for <stable@vger.kernel.org>; Fri,  7 Aug 2020 07:20:27 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id v15so889384pgh.6
        for <stable@vger.kernel.org>; Fri, 07 Aug 2020 07:20:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=GTTtdNHDAOFTtgj5u4twoS6swA3QlbmXXFKyW7vlPcc=;
        b=mSfkldD4x8HvJI2boI/MZV56UtLLw0qIwm6AwOhqszHVjZNM5UBH9OYJe8m9Af+Zqw
         ysWQsohryP0LVPUqYixjIdHbb/FxtoOG/M8KoMVKFfhPutNvvKytSe7ZohPH29cwnuVv
         fb8B3Z/3/uWHfOsT7llPPCxYSj0vipMi4v1CgshQ9uNG9UVOxLJcYbyBh0Uvx7MutYap
         XEdUqE8aAzodsK2V8fA9PLjltioozJhCaJhtXTwERYh6/4DK65WGlhQfgpgp3QWVQFLC
         /CksMReZ6rWgbxkouayYqvzmGr6G05cwyGLj9+vL4AOT8Ix3cYt+IcPQgKqyF4I28Y+9
         w4ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=GTTtdNHDAOFTtgj5u4twoS6swA3QlbmXXFKyW7vlPcc=;
        b=ia8xtTCAQe48Aqs0yEq1+DsQG2RG0/2t4QNjram+BcF2R76I/tcS0em0HIzbu8tSW3
         u3OH2XAHuRmHZou8Tba7GjYBUb9ZLzG0U/i/eHHNtW2J+MI6oYgeuzmIysGcDWiyhem6
         NfwPJSf37Uu0IaB65wEGa5BHeLkp4Foz/DX5mEB6nk5dA0luBgDuiwxJwIIQZKlS/tY2
         VV+Qzw0dwtmnSiNG6ZIbQbMgbVztots12eXLWejioVCJICZPx0gePyuugtCWOLvD9+Ki
         SAlP4Gd7Tc5olmjK1Z+CpWD3kqAxkMKlAlesTat0yyvymiyDrIpAGxx7Q7XCeZGy+qb2
         dDUA==
X-Gm-Message-State: AOAM533xMW53HV8gCZsBW7ZxYVa3YP1Pex+rTUhYMJugxUQfo5E8W5zk
        gDYmU1BZL9Qq6UWRWmcOnQmgEnXYKlo=
X-Google-Smtp-Source: ABdhPJxq7F6nhMuOoQmOHjvcXNxsIjUOTX3VgDK+V0/4zSSuDEl4vRigXRgglZiH+arzAXP+51q8Lw==
X-Received: by 2002:aa7:980f:: with SMTP id e15mr13164978pfl.194.1596810026628;
        Fri, 07 Aug 2020 07:20:26 -0700 (PDT)
Received: from [192.168.1.182] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id x15sm13488567pfr.208.2020.08.07.07.20.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 Aug 2020 07:20:26 -0700 (PDT)
Subject: Re: FAILED: patch "[PATCH] io_uring: don't touch 'ctx' after
 installing file descriptor" failed to apply to 5.8-stable tree
To:     gregkh@linuxfoundation.org, sgarzare@redhat.com
Cc:     stable@vger.kernel.org
References: <1596806938115186@kroah.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <33b4b776-76d0-1231-880d-17fae0f90e72@kernel.dk>
Date:   Fri, 7 Aug 2020 08:20:24 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <1596806938115186@kroah.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 8/7/20 7:28 AM, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 5.8-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

You can ignore this one, not sure why it has a stable label... It
doesn't affect 5.8.

-- 
Jens Axboe

