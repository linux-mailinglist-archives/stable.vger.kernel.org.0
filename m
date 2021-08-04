Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8048C3DFB6C
	for <lists+stable@lfdr.de>; Wed,  4 Aug 2021 08:25:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234831AbhHDGZw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Aug 2021 02:25:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233280AbhHDGZv (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Aug 2021 02:25:51 -0400
Received: from lahtoruutu.iki.fi (lahtoruutu.iki.fi [IPv6:2a0b:5c81:1c1::37])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11164C0613D5;
        Tue,  3 Aug 2021 23:25:39 -0700 (PDT)
Received: from [10.32.112.20] (55862176.cust.multi.fi [85.134.33.118])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: tmb)
        by lahtoruutu.iki.fi (Postfix) with ESMTPSA id 388791B001E8;
        Wed,  4 Aug 2021 09:25:35 +0300 (EEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=iki.fi; s=lahtoruutu;
        t=1628058335;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wxtt8KNuWwpP7gtvj6O94l8wyhQFK14FxF4B830ik+k=;
        b=d/pxRZXfthkNC6xGq8HNha1T3HjDzc+spHVHA1P4d7vTGTm0R1vDXzRlqB5okijQgNPC6Y
        ewgZexVVtghUM1uwOBw1heKxF4jugd4FVDjWcsvRRZhBoXmDARhUyXYYWNo9r3aRtIQHdD
        8lOs2sdMD71tgrsDQh0zsixdBxH8dB1zGjihOV7scFjSwYS/3hdgBV3V+/u002YBkJfGQz
        mhfCJlrTDqPv7WvRrlnl3tyTR9hVSrN5pM9x/d0MQK6vKPBmhFqjktALTP9OoRLG29aDhX
        ZqhNbx2/lKrF96C3H4fUgoh5g7kKNYXk/1mvbcSUCNLE3Nr/GI79fHcLEyBDAQ==
Subject: Re: [PATCH 5.10 00/67] 5.10.56-rc1 review
To:     Pavel Machek <pavel@denx.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
References: <20210802134339.023067817@linuxfoundation.org>
 <20210803192607.GA14540@duo.ucw.cz>
From:   Thomas Backlund <tmb@iki.fi>
Message-ID: <e591d78c-0196-a218-59dd-91d83aa65f90@iki.fi>
Date:   Wed, 4 Aug 2021 09:25:34 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210803192607.GA14540@duo.ucw.cz>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: sv
Content-Transfer-Encoding: 7bit
ARC-Authentication-Results: i=1;
        ORIGINATING;
        auth=pass smtp.auth=tmb smtp.mailfrom=tmb@iki.fi
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=iki.fi;
        s=lahtoruutu; t=1628058335;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wxtt8KNuWwpP7gtvj6O94l8wyhQFK14FxF4B830ik+k=;
        b=p9XqdDbKzBPrZybQvzAqglHBkNNWRh9BQNVd2/981R+eLCajaOqhnynKLYt7gL41q4DMWo
        7SpT/wOVjeWG9hTAyPrgY4H+HjgYiKv0va1xAA+jr8P6F1PdlysSuhKhr6gWnnIWojV5DD
        cgpEktxVGcKMmcHUUsexycZjH+Nz62vtCh56stvNfTnj3CWxEOLNSNdMuDYKjbiM+l2pJZ
        Hpc3IxDRotpFgJf9LHU1WA8yX8hFDKyGFoEU7K3sFCmikex1uuaP7JOP2MLMmYt/AgPhdX
        at2/M9mZQueL6ubE2NCVs7A4w8ZUhFPxFGnHDuZIs7M5YgKGQHCUTf8ch2L6LQ==
ARC-Seal: i=1; s=lahtoruutu; d=iki.fi; t=1628058335; a=rsa-sha256;
        cv=none;
        b=GLrdONjZ15KCe67xuhNxmDuv9dGd8U7vnCEQietyqwk5L/3pQZ6VX8U9TIclG0ucVsh2Wt
        spXRntV4aZCmNyUqXSEFUSwIXahTGMAeCDswLvLQ9ZyLFQF2qNbPewhJxptDijBLEivDpU
        3/quacx77s21C/z2Y9FNcO6t+c3z2CbOVIL53zWzSGUP89H+nav+6FXg6DRn0f+yosIRoW
        JlS83fmQbV+2lrDS67bjKHuEcOVW+O/+Sm6eLkwCYSEc0Q6h2vTmfjNoOKVnJHU1RNR7tm
        VJb6eL1AdddTk9/DnkStfu/Q4j0XyqJ4bDnOJzwjC5zERDPor6PNPsvtGHXBMQ==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Den 03-08-2021 kl. 22:26, skrev Pavel Machek:
> Hi!
> 
>> This is the start of the stable review cycle for the 5.10.56 release.
>> There are 67 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
> 
> Not sure what went wrong, but 50 or so patches disappeared from the queue:
> 
> 48156f3dce81b215b9d6dd524ea34f7e5e029e6b (origin/queue/5.10) btrfs: fix lost inode on log replay after mix of fsync, rename and inode eviction
> 474a423936753742c112e265b5481dddd8c02f33 btrfs: fix race causing unnecessary inode logging during link and rename
> 2fb9fc485825505e31b634b68d4c05e193a224da Revert "drm/i915: Propagate errors on awaiting already signaled fences"
> b1c92988bfcb7aa46bdf8198541f305c9ff2df25 drm/i915: Revert "drm/i915/gem: Asynchronous cmdparser"
> 11fe69a17195cf58eff523f26f90de50660d0100 (tag: v5.10.55) Linux 5.10.55
> 984e93b8e20731f83e453dd056f8a3931b4a66e5 ipv6: ip6_finish_output2: set
> sk into newly allocated nskb
> 
> Best regards,

Looks like a fallout of switching to use rc-* for current review queues 
and apparently keep queue-* for upcoming stuff

https://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git/tree/ 



--
Thomas
