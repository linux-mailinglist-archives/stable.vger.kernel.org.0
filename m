Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 644EC1C4012
	for <lists+stable@lfdr.de>; Mon,  4 May 2020 18:38:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729586AbgEDQiJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 May 2020 12:38:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729459AbgEDQiJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 May 2020 12:38:09 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35339C061A0E
        for <stable@vger.kernel.org>; Mon,  4 May 2020 09:38:09 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id d7so8106499ioq.5
        for <stable@vger.kernel.org>; Mon, 04 May 2020 09:38:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=bR7wm4gFsEWI1kXOpXJAK2Dpue/6I3kHLvZ7pCStN6c=;
        b=1pVw0SpE3LeCQgksw+Hn3fmkL4jPYcampBnrA9X5k2Fv0923PgBU01RziIckxXXTTS
         v64ndP39euojJFwmL7gHs1abFqIJ29FGYHbzSdDsfhHKAc6denXCRnobPAH03I80RzKS
         4UxQNCdkNq3BecAVXuyvPgd1+eebca0ukxGbKal9u5spNkBa04IU9sCvFFKpZ5dZppjV
         S48NzZMEOfGmhJUu2Nu8RZI9+9B7h1mtDEM9ecne7eCgWTOBRQAKJlKkV+7AXutCKigX
         qUROIwxIR6i502Yda/K6wbc9DkegwRLY+vmDyAUhEMvN1QxSOdBWBSvOdXy9R+q2WqiA
         50cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=bR7wm4gFsEWI1kXOpXJAK2Dpue/6I3kHLvZ7pCStN6c=;
        b=AVioYZONT1Xmp00eHXbeiH8s8nZMS+ponWD+7LCdvbqkkY+DEnNSkVNle3dSmpUu+b
         0bsPexjDRcnNFRntwYbVzc31FJ6B4BeyNKUHWRFokccwVWI1aG5BkLXkRskNHWzbRdmn
         Wsz3usBM3N3tJwWSlHkFqasUyLyOtX6X7iQXwIbPQgHAeXolnAbmK018zo4ZOh/eyQBk
         ixmk9vIzQGI9h7PGnlorbjK2nSGHEpqtJkSDuea425XrdIatJjxQWSM773nuc67JPuKo
         v/nXgo4kintkj/6cpRE+t0WOtTyZPqRyozlLy6eQcZjYsBPVIG+CfjcpmQODQEZWNkif
         iS7g==
X-Gm-Message-State: AGi0Pua3674l7/ImG47s8Po27qyUf9jBozCRq+1+WJULDd8IJOs6FpRY
        pcmPkxnFU1pL9L1Z0d3wlyrkpig/bKPVyw==
X-Google-Smtp-Source: APiQypJ0hVIbtZa2dD5peS8iMQsGNOrwREYEjf7Yt/tZBTGiCu+wDA6O74Du6ftD+q9nRKFdjXC0Rg==
X-Received: by 2002:a5e:a610:: with SMTP id q16mr16277962ioi.75.1588610288181;
        Mon, 04 May 2020 09:38:08 -0700 (PDT)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id 23sm5392262ilv.58.2020.05.04.09.38.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 May 2020 09:38:07 -0700 (PDT)
Subject: Re: FAILED: patch "[PATCH] io_uring: statx must grab the file table
 for valid fd" failed to apply to 5.6-stable tree
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     bugs@claycon.org, stable@vger.kernel.org
References: <1588586161159248@kroah.com>
 <a4390838-d86d-2b0e-ec18-12ee0b74ab7f@kernel.dk>
 <20200504163632.GA2724164@kroah.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <e00ac2cb-b896-ce56-adab-4893781e4f1d@kernel.dk>
Date:   Mon, 4 May 2020 10:38:06 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200504163632.GA2724164@kroah.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 5/4/20 10:36 AM, Greg KH wrote:
> On Mon, May 04, 2020 at 07:46:56AM -0600, Jens Axboe wrote:
>> On 5/4/20 3:56 AM, gregkh@linuxfoundation.org wrote:
>>>
>>> The patch below does not apply to the 5.6-stable tree.
>>> If someone wants it applied there, or to any other stable or longterm
>>> tree, then please email the backport, including the original git commit
>>> id to <stable@vger.kernel.org>.
>>
>> Here's a 5.6 backport.
> 
> Thanks, now queued up.

Thanks Greg!

-- 
Jens Axboe

