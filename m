Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88DFC45684E
	for <lists+stable@lfdr.de>; Fri, 19 Nov 2021 03:53:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231789AbhKSC41 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Nov 2021 21:56:27 -0500
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:42819 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230059AbhKSC40 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Nov 2021 21:56:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1637290406; x=1668826406;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=v+XO89uBWD9Pk6mvMuKrXgEqD/DpMkl+v7f661DW/hs=;
  b=oAesm2ROwusylXo7UX9lSFHFql4gEBKBuH5/Gunch3jzjngO6/kyOfeZ
   hL4WAcMOdbUtS8OLb2Fr4oy2E/3RAfZtjJqU1wf9Bn9nPknxAUfScbZo3
   oQwEU5g3zubaEwjurl+wxLf8EG3jR5zfOQgM0ewSl1k2E3J4D9r26VCdB
   H8nY9Bi6tZOb4WI6069UlWAImw5uqujpAIPLB20x2QBkLfXG5iEBkdgkx
   RTuOqdibkcmPL1v3XZgyTgEpsh+mBZI1p4ErNhnRUmS1fCeQiacujSFQo
   vqNYy2CUl1hRbGWY8w1QkpqvuMrwkuJZaUdeUf3Sl5f+dWE71ocWJ2PDj
   A==;
X-IronPort-AV: E=Sophos;i="5.87,246,1631548800"; 
   d="scan'208";a="185028218"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 19 Nov 2021 10:53:25 +0800
IronPort-SDR: vq6vF0A2QESAnNrxMFN/pi8ZcardyMJ7+FCN/o6+beLgZA+c3inSjORv215/++3IxDjQ/iixy/
 UPBZzzD7f1w67n4AZfwp7X9G6xemWPDv/R4avn6ne2ULHOY9G4pod8Xod/fmTeoWhOWyxab2+Z
 yBZFJ75luEvPBjX2kViTlU89cYYBTytbWLg7lUDbOMUL2Q+Dk8q+N551OKE9mTEsaF7od+ffm8
 pD9TSJQGLf++ddMEChMT0wNQfEbvgG6+5luoHKOSijGAUjXRW7W2EGCJs26pzhQYQ5lc+AHlOV
 Y4BJZ2jkJIOXMMGw/qwIb4eB
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Nov 2021 18:28:25 -0800
IronPort-SDR: kFkhYn+AAjQTXNMIPvVnCwWZMgzWka9EJYsRVdNhYaHVj3BoKzUd+EEqBfS0J12woxtx2xsSAm
 zsZcBEuFpwo7ous3x8PFlQd9QQdv+U705Oy5O+NW9ceDFSJhDyAjVs/pXIEwYbsaRs9TpqjiOw
 YYiHaTWdAiPDS10qig2LDTpQ+Ar0uBn9sqtb89Zym4RYv8Ek4isowxcULDZbuUzY9BxZyPH4As
 sE+woh0DZPlC6VqE0WbMJdCa8B/8MdeCi00kOqeEPjwUWnxnoUDSko+cbAYMrA278taH9D4b9p
 zrI=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Nov 2021 18:53:27 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4HwLnx49V7z1RtVt
        for <stable@vger.kernel.org>; Thu, 18 Nov 2021 18:53:25 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1637290404; x=1639882405; bh=v+XO89uBWD9Pk6mvMuKrXgEqD/DpMkl+v7f
        661DW/hs=; b=YCsDSKeqUoUjkav2aOdXKJy4tnOb+ezP/MLkMYwJEwNaJtuNQ5q
        vjsv2p6bOXt7O+1MetdINniyu8dJ0fpVfEDeSkdi7lR+t3o+0a+HLA9Fe7rP9ee3
        3csuu7GMqBJERZpw4t2NYKfDGOiBp8wE+x4vX0Sw1XuDlnnBwQV9IKXUIW9ILljj
        ByLFKjM2rtWwODaWo5HJLzSuUUKU6xyei65lyJ/3768VhNxMQy7n5gEI4JAjY6AK
        b+tE1qD7QxKN4HqcGgihWuoTQ2gMFa7PMpMfD9+L1FaPRRWLd3dGYzN98hwujDjI
        nFUMpVnNrvjIRzH8wgCnEv+7hXCMg2QGWIg==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id VHO5ViRD55LK for <stable@vger.kernel.org>;
        Thu, 18 Nov 2021 18:53:24 -0800 (PST)
Received: from [10.225.54.48] (unknown [10.225.54.48])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4HwLnv2RJnz1RtVl;
        Thu, 18 Nov 2021 18:53:23 -0800 (PST)
Message-ID: <68ff6cd4-41f7-59e7-300e-566be26f26f0@opensource.wdc.com>
Date:   Fri, 19 Nov 2021 11:53:21 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.1
Subject: Re: [PATCH 5.15] block: Add a helper to validate the block size
Content-Language: en-US
To:     Tadeusz Struk <tadeusz.struk@linaro.org>, stable@vger.kernel.org
Cc:     axboe@kernel.dk, hch@lst.de, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+662448179365dddc1880@syzkaller.appspotmail.com,
        xieyongji@bytedance.com
References: <7e6c4c23-f071-f33b-7bd4-da11980d34c6@linaro.org>
 <20211118235738.1128085-1-tadeusz.struk@linaro.org>
 <df37d57e-86e1-56dd-54b7-f3d7b96ffd56@opensource.wdc.com>
 <debb322e-395d-90a9-2052-0cf69d96f024@linaro.org>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital
In-Reply-To: <debb322e-395d-90a9-2052-0cf69d96f024@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2021/11/19 11:41, Tadeusz Struk wrote:
> On 11/18/21 17:55, Damien Le Moal wrote:
>> But where is this used in 5.15 ? I do not see any callers for this.
>> So why backport it ?
> It will be used after the
> af3c570fb0df ("loop: Use blk_validate_block_size() to validate block size")
> is applied.
> Please read the first message in the thread to get the context.

None of the patches in that series are marked for stable. If you want all of
them backported, sending all patches together as a series would make things
easier to understand.


-- 
Damien Le Moal
Western Digital Research
