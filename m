Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAD5522F67F
	for <lists+stable@lfdr.de>; Mon, 27 Jul 2020 19:24:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728714AbgG0RYI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jul 2020 13:24:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726617AbgG0RYI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jul 2020 13:24:08 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42C8FC061794
        for <stable@vger.kernel.org>; Mon, 27 Jul 2020 10:24:08 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id t6so10155555pgq.1
        for <stable@vger.kernel.org>; Mon, 27 Jul 2020 10:24:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=dn2px5MDWJBteG4RENCaY1+4sM02qDLJiALVak0Xch8=;
        b=cfy/XvHfnpJAheYU6PYRUdjFjDPbInZv70IGbcPxwtk2PXbinbgV6Ws5Lc2Z0tAcJS
         1JPXNtyI/UGRf/lLzt2uRf1RLPKWjSFVXygeFk4IvgtIympIP37v6Z1zki+FDwz+Lkri
         SPfri9q9EZnaXgCvcU7GWplNXaLuVGQTFVbx0lU23BH94knL+iY9MhXnnMjgJWCrtUwz
         a+QoGky+r7CRF/fYL+82++6uxK5wpw2YOaLK4glLHCvKJM5KNSVVVJz8kpyJYiM2bxkg
         Ra1ShvpPgIsZH8ZPXdo7KCc4+PiQDJW4lrYcYkaaSzSYjPjXgDog/vhriJ8iRsBiR+aJ
         pUmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=dn2px5MDWJBteG4RENCaY1+4sM02qDLJiALVak0Xch8=;
        b=LMb9sYsHCy50jTC8dabF3jRqdPoLy7FtxzYjVeWu/1mLBax3QDSjMo9Iutv4RU5UDk
         vtmjgq0QpjE4P+e9c/BwZcFwD9Zu3S7yX87FGU+fe4DJtO5krCCy3zaKh6ODkmbcMuqc
         RCjanWyyAV1NHLPVPb3Y7WasbYKfZMftiafICyBc2QJO5oLgO4DHihH2n/vIsNjqiaux
         mm5hODxeaGHQLE95igG1j43BzjTuWTmRNT74bequt9GqUkMFmmvyWOY731UfIKl0VxN4
         6jLgkgLsErQYhIoc+xUfeHIPZMZ6fLPQHcgfTwJAzXcQhkd7r1wXHyrGCHVwrCzBIMy1
         vorQ==
X-Gm-Message-State: AOAM533VLjiCroEbvPC+Uaio2iRGw688mzbw5KrqQOAr9vxHMO/F9fLd
        mhjZ9LlOeRdwfEGEfWWQ8c1CNAbFqeI=
X-Google-Smtp-Source: ABdhPJw02Y1CBOi9eyKAN/d7sednBqTbvm7vezEAYUYJf76CVVw4MURcMENwZc0CuYF6Lz0Fye/CvA==
X-Received: by 2002:a63:6c0a:: with SMTP id h10mr20781174pgc.11.1595870647563;
        Mon, 27 Jul 2020 10:24:07 -0700 (PDT)
Received: from [192.168.1.182] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id fh14sm177655pjb.38.2020.07.27.10.24.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Jul 2020 10:24:06 -0700 (PDT)
Subject: Re: FAILED: patch "[PATCH] io_uring: ensure double poll additions
 work with both request" failed to apply to 5.7-stable tree
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org
References: <159585645969173@kroah.com>
 <cb5acf7a-31b5-81c4-874b-366dba951f16@kernel.dk>
 <20200727152115.GA194978@kroah.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <37279bed-41b0-26bf-30ba-4ef4c38bcdeb@kernel.dk>
Date:   Mon, 27 Jul 2020 11:24:05 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200727152115.GA194978@kroah.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 7/27/20 9:21 AM, Greg KH wrote:
> On Mon, Jul 27, 2020 at 08:59:08AM -0600, Jens Axboe wrote:
>> On 7/27/20 7:27 AM, gregkh@linuxfoundation.org wrote:
>>>
>>> The patch below does not apply to the 5.7-stable tree.
>>> If someone wants it applied there, or to any other stable or longterm
>>> tree, then please email the backport, including the original git commit
>>> id to <stable@vger.kernel.org>.
>>
>> Here's the 5.7 variant:
> 
> Thanks, I'll queue it up for the next release after this one.

Not a huge issue for this particular one, but it's fixing a regression
from a patch that was auto-selected into -stable. So would be nice to
get it closed up sooner rather than later.

-- 
Jens Axboe

