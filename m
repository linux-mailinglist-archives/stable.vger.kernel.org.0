Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A52CDCBA3
	for <lists+stable@lfdr.de>; Fri, 18 Oct 2019 18:38:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405941AbfJRQgL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Oct 2019 12:36:11 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:37398 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730786AbfJRQgL (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Oct 2019 12:36:11 -0400
Received: by mail-pf1-f195.google.com with SMTP id y5so4213914pfo.4
        for <stable@vger.kernel.org>; Fri, 18 Oct 2019 09:36:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=Bye135gwA1svZblRSZCCqjJ0pb5KXJ36Pgiefcf2DQY=;
        b=JqjIkhRx2SvqMM1489kPjibumhUQKoZNWSY3TZ/nKULBQFgG5OQSKI2BCTJJ7D5Uih
         wPwEy/nlsOwbvqwLjuUTvjy+u7C74Nh/PmLWkqrTif8X2y2SorrUynVHI92/JZ8WXGFE
         JumSiErFubDM+PEttZ9RQmguyAda29gp1fPX0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=Bye135gwA1svZblRSZCCqjJ0pb5KXJ36Pgiefcf2DQY=;
        b=nrbea/f7vbW3jpzb/ygIe/LVODFqL2AY9no7/Bfw5z3Q7LMVg0GrEObU5U0WJdG36h
         PZhHi12jRsA42a3+H0gteDAJV3hvffy4658D33zd1mxH8BiyDGhI1GUySZQDsH0Esc4t
         oBUyettunekGChBWtYxqWVUVZfFasvD+xSAucTTayLLqwARUU9OhVrz/4z/JIuvD5UzK
         yUkI+3JyMNmICVJ+BRmTtZmH6xZS2dN5MjIoupRXQ12u22+BSYmvL56cnM1pGASt0YXO
         bP+YRil5YGC0VD3oZuO8Mh0hncg+KqYuXBHD6IlvGkXCLeHxclWE6r0z+eRELXZpnnVj
         Z8ig==
X-Gm-Message-State: APjAAAVkZlHZ/hveCcO6JPc84MVVmwbMVELLJhSV+Y2MneY/wHdezdc2
        3FJAxpPIjrotDIbZFvXplnBeuqrJZoTyEEcoHS0NAL94ya/IcUCpPiOwHIQIr537Ck4+1QI9pol
        ZFEPrBWRn7MUwHLrtnUaVzz1CBHssVPHEQXHFW6RG8LmraOnu6M5YJlPffWonQ1POfK7d0mg=
X-Google-Smtp-Source: APXvYqzD/qt6MHkD1pK6flLL5LHVVOJ2Ajha+rl3DPyHpe600uM4wBypQgjk0Zslwx2Zxy0J0/N8tw==
X-Received: by 2002:aa7:9842:: with SMTP id n2mr7883881pfq.258.1571416570119;
        Fri, 18 Oct 2019 09:36:10 -0700 (PDT)
Received: from [10.69.45.46] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id e127sm7457161pfe.37.2019.10.18.09.36.04
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 18 Oct 2019 09:36:07 -0700 (PDT)
Subject: Re: [PATCH] lpfc: remove left-over BUILD_NVME defines
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Hannes Reinecke <hare@suse.de>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org,
        Martin George <martin.george@netapp.com>,
        Daniel Wagner <daniel.wagner@suse.com>,
        Hannes Reinecke <hare@suse.com>,
        James Smart <james.smart@broadcom.com>,
        stable <stable@vger.kernel.org>
References: <20191017150019.75769-1-hare@suse.de> <yq1eezake0f.fsf@oracle.com>
From:   James Smart <james.smart@broadcom.com>
Message-ID: <0e739a86-a462-9d44-9ef9-24a4488c0d87@broadcom.com>
Date:   Fri, 18 Oct 2019 09:36:02 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <yq1eezake0f.fsf@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/17/2019 7:01 PM, Martin K. Petersen wrote:
> Hannes,
>
>> The BUILD_NVME define never got defined anywhere, causing NVMe
>> commands to be treated as SCSI commands when freeing the buffers.
>> This was causing a stuck discovery and a horrible crash in
>> lpfc_set_rrq_active() later on.
> Applied to 5.4/scsi-fixes, thanks!
>

The offending patches that introduced the define are:

 From 12.2.0.0:
scsi: lpfc: Move SCSI and NVME Stats to hardware queue structures
commit    4c47efc140fa926f00aa59c248458d95bd7b5eab
 From 12.4.0.0:
scsi: lpfc: Merge per-protocol WQ/CQ pairs into single per-cpu pair
commit    c00f62e6c5468ed0673c583f1ff284274e817410

The 12.2 patch just misses some stats - no big deal.
But the 12.4 patch introduces a logic error, and is in the head of the 
stable tree.

I assume that 5.4/scsi-fixes will get merged into 5.4 pre-release, and 
that the stable tree will rebase to pick it up ?

-- james


