Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EDF94B77E4
	for <lists+stable@lfdr.de>; Tue, 15 Feb 2022 21:51:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243886AbiBOUCS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Feb 2022 15:02:18 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243889AbiBOUCR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Feb 2022 15:02:17 -0500
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 073D674DC1
        for <stable@vger.kernel.org>; Tue, 15 Feb 2022 12:02:04 -0800 (PST)
Received: by mail-io1-xd30.google.com with SMTP id s1so1836817ioe.0
        for <stable@vger.kernel.org>; Tue, 15 Feb 2022 12:02:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=Si7xSPd1JwjfXW+B+aAamikI56prZYe0E+1qng2t7lw=;
        b=wcHw6TKZekPjNs+I43XHIbJJF7yP5LBRmacmWyiAqhidTuRrtIXGHvQKK+yGJSuJW+
         GaxTMLRLOIWwdrDPKtQ+XUycDOojggE1tPvkBYTNqHC1kEpPun2QuB1ywua571sjfXXX
         yrM3Jq+8kLxnne4GcOL2Hp8P3khcs2YmAsbc09EJbwGx433EAYrFILhE6qEGPBUEQ7bC
         tBDr+rDWGh+BsblicHfoDoFDZTIZ/AFClBs9drp/JYQUCJJCP7O4lA4/tKlXUr0gp/dG
         QkIiYNGSmSH13Mjt6ZT7ggZNCLiKgBsm/CSui0I/OTzhdhBK53aDo1vDiRtA5HbPeXdm
         /YeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Si7xSPd1JwjfXW+B+aAamikI56prZYe0E+1qng2t7lw=;
        b=S02IapxBjI2r0IQ5Vti7E/i+zTAKY0zbHTR4bbNX+zCvn1fTKwhnKoPHGs1lw7BQ0H
         hziS2lWQUGsjJveIxC5O7CdVa/d4vIpAB4GEiNUkEGPB5kYkTMre9Mer47DAisqSOJa7
         Wkxyotn1S26YralRwJqAvD28dwoBwdoegCuFjBu6CYRXzfIOMMioQKrW3pL4ZF/cYaNI
         3xVnl5NFQ92prGOgWWOdAp+dNnx4XXFvU3QMZ6nxJM/Pktsvo8maGM5QFharLSAqdo/f
         FN3WK0Ku57xkC9aTCTuT5dNhZ8ZDq6RUPQkfUF7fNgskvCANNNAFJlvNjyOTHgC1/gae
         lGnA==
X-Gm-Message-State: AOAM530sDNpxWMl8PI1DGbne9KNhIWs26MNyyKmMgdQCZExPBuSe0IsM
        232Ac//4wV3buHPit0caBlj3og==
X-Google-Smtp-Source: ABdhPJyPD7vMRAv8grrVO0jJ+ClGxxFeaDtlAcn09WPwThKQAfm0aDXXAEAB2OmEmE0ipxIxdNaj3w==
X-Received: by 2002:a05:6602:3159:: with SMTP id m25mr329456ioy.114.1644955323269;
        Tue, 15 Feb 2022 12:02:03 -0800 (PST)
Received: from [172.22.22.4] (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.googlemail.com with ESMTPSA id t5sm8329430ilu.74.2022.02.15.12.02.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Feb 2022 12:02:02 -0800 (PST)
Message-ID: <2ddfa2c9-0e03-e4f7-e0e5-78230bef43fe@linaro.org>
Date:   Tue, 15 Feb 2022 14:02:01 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v3 02/25] bus: mhi: Fix MHI DMA structure endianness
Content-Language: en-US
To:     Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        mhi@lists.linux.dev
Cc:     quic_hemantk@quicinc.com, quic_bbhatt@quicinc.com,
        quic_jhugo@quicinc.com, vinod.koul@linaro.org,
        bjorn.andersson@linaro.org, dmitry.baryshkov@linaro.org,
        quic_vbadigan@quicinc.com, quic_cang@quicinc.com,
        quic_skananth@quicinc.com, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Paul Davey <paul.davey@alliedtelesis.co.nz>,
        stable@vger.kernel.org
References: <20220212182117.49438-1-manivannan.sadhasivam@linaro.org>
 <20220212182117.49438-3-manivannan.sadhasivam@linaro.org>
From:   Alex Elder <elder@linaro.org>
In-Reply-To: <20220212182117.49438-3-manivannan.sadhasivam@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2/12/22 12:20 PM, Manivannan Sadhasivam wrote:
> From: Paul Davey <paul.davey@alliedtelesis.co.nz>
> 
> The MHI driver does not work on big endian architectures.  The
> controller never transitions into mission mode.  This appears to be due
> to the modem device expecting the various contexts and transfer rings to
> have fields in little endian order in memory, but the driver constructs
> them in native endianness.

Yes, this is true.

> Fix MHI event, channel and command contexts and TRE handling macros to
> use explicit conversion to little endian.  Mark fields in relevant
> structures as little endian to document this requirement.

Basically every field in the external interface whose size
is greater than one byte must have its endianness noted.
 From what I can tell, you did that for all of the exposed
structures defined in "drivers/bus/mhi/core/internal.h",
which is good.

*However* some of the *constants* were defined the wrong way.

Basically, all of the constant values should be expressed
in host byte order.  And any needed byte swapping should be
done at the time the value is read from memory--immediately.
That way, we isolate that activity to the one place we
interface with the possibly "foreign" format, and from then
on, everything may be assumed to be in natural (CPU) byte order.

I will point out what I mean, below.

> Fixes: a6e2e3522f29 ("bus: mhi: core: Add support for PM state transitions")
> Fixes: 6cd330ae76ff ("bus: mhi: core: Add support for ringing channel/event ring doorbells")
> Signed-off-by: Paul Davey <paul.davey@alliedtelesis.co.nz>
> Cc: stable@vger.kernel.org
> Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
> ---
>   drivers/bus/mhi/core/debugfs.c  |  26 +++----
>   drivers/bus/mhi/core/init.c     |  36 +++++-----
>   drivers/bus/mhi/core/internal.h | 119 ++++++++++++++++----------------
>   drivers/bus/mhi/core/main.c     |  22 +++---
>   drivers/bus/mhi/core/pm.c       |   4 +-
>   5 files changed, 104 insertions(+), 103 deletions(-)
> 
> diff --git a/drivers/bus/mhi/core/debugfs.c b/drivers/bus/mhi/core/debugfs.c
> index 858d7516410b..d818586c229d 100644
> --- a/drivers/bus/mhi/core/debugfs.c
> +++ b/drivers/bus/mhi/core/debugfs.c
> @@ -60,16 +60,16 @@ static int mhi_debugfs_events_show(struct seq_file *m, void *d)
>   		}

These look fine, because they're doing the conversion of the
fields just as they're read from memory.

>   		seq_printf(m, "Index: %d intmod count: %lu time: %lu",
> -			   i, (er_ctxt->intmod & EV_CTX_INTMODC_MASK) >>
> +			   i, (le32_to_cpu(er_ctxt->intmod) & EV_CTX_INTMODC_MASK) >>
>   			   EV_CTX_INTMODC_SHIFT,
> -			   (er_ctxt->intmod & EV_CTX_INTMODT_MASK) >>
> +			   (le32_to_cpu(er_ctxt->intmod) & EV_CTX_INTMODT_MASK) >>
>   			   EV_CTX_INTMODT_SHIFT);

. . .

> diff --git a/drivers/bus/mhi/core/init.c b/drivers/bus/mhi/core/init.c
> index af484b03558a..4bd62f32695d 100644
> --- a/drivers/bus/mhi/core/init.c
> +++ b/drivers/bus/mhi/core/init.c
> @@ -293,17 +293,17 @@ int mhi_init_dev_ctxt(struct mhi_controller *mhi_cntrl)
>   		if (mhi_chan->offload_ch)
>   			continue;
>   
> -		tmp = chan_ctxt->chcfg;
> +		tmp = le32_to_cpu(chan_ctxt->chcfg);
>   		tmp &= ~CHAN_CTX_CHSTATE_MASK;

Note that CHAN_CTX_CHSTATE_MASK, etc. here are assumed to
be in CPU byte order.  This is good, and that pattern is
followed for a bunch more code that I've omitted.

>   		tmp |= (MHI_CH_STATE_DISABLED << CHAN_CTX_CHSTATE_SHIFT);
>   		tmp &= ~CHAN_CTX_BRSTMODE_MASK;
>   		tmp |= (mhi_chan->db_cfg.brstmode << CHAN_CTX_BRSTMODE_SHIFT);
>   		tmp &= ~CHAN_CTX_POLLCFG_MASK;
>   		tmp |= (mhi_chan->db_cfg.pollcfg << CHAN_CTX_POLLCFG_SHIFT);
> -		chan_ctxt->chcfg = tmp;
> +		chan_ctxt->chcfg = cpu_to_le32(tmp);
>   
> -		chan_ctxt->chtype = mhi_chan->type;
> -		chan_ctxt->erindex = mhi_chan->er_index;
> +		chan_ctxt->chtype = cpu_to_le32(mhi_chan->type);
> +		chan_ctxt->erindex = cpu_to_le32(mhi_chan->er_index);
>   
>   		mhi_chan->ch_state = MHI_CH_STATE_DISABLED;
>   		mhi_chan->tre_ring.db_addr = (void __iomem *)&chan_ctxt->wp;

. . .

> diff --git a/drivers/bus/mhi/core/internal.h b/drivers/bus/mhi/core/internal.h
> index e2e10474a9d9..fa64340a8997 100644
> --- a/drivers/bus/mhi/core/internal.h
> +++ b/drivers/bus/mhi/core/internal.h
> @@ -209,14 +209,14 @@ extern struct bus_type mhi_bus_type;
>   #define EV_CTX_INTMODT_MASK GENMASK(31, 16)
>   #define EV_CTX_INTMODT_SHIFT 16
>   struct mhi_event_ctxt {
> -	__u32 intmod;
> -	__u32 ertype;
> -	__u32 msivec;
> -
> -	__u64 rbase __packed __aligned(4);
> -	__u64 rlen __packed __aligned(4);
> -	__u64 rp __packed __aligned(4);
> -	__u64 wp __packed __aligned(4);

These are all good.

> +	__le32 intmod;
> +	__le32 ertype;
> +	__le32 msivec;
> +
> +	__le64 rbase __packed __aligned(4);
> +	__le64 rlen __packed __aligned(4);
> +	__le64 rp __packed __aligned(4);
> +	__le64 wp __packed __aligned(4);
>   };

This is separate from the subject of this patch, but I'm
pretty sure the entire structure (rather than all of those
fields) can be defined with the __packed and __aligned(4)
attributes to achieve the same effect.

>   #define CHAN_CTX_CHSTATE_MASK GENMASK(7, 0)

. . .

> @@ -277,57 +277,58 @@ enum mhi_cmd_type {
>   /* No operation command */
>   #define MHI_TRE_CMD_NOOP_PTR (0)
>   #define MHI_TRE_CMD_NOOP_DWORD0 (0)
> -#define MHI_TRE_CMD_NOOP_DWORD1 (MHI_CMD_NOP << 16)
> +#define MHI_TRE_CMD_NOOP_DWORD1 (cpu_to_le32(MHI_CMD_NOP << 16))

This just looks wrong to me.  The original definition
should be fine, but then where it's *used* it should
be passed to cpu_to_le32().  I realize this might be
a special case, where these "DWORD" values are getting
written out to command ring elements, but even so, the
byte swapping that's happening is important and should
be made obvious in the code using these symbols.

This comment applies to many more similar definitions
below.  I don't know; maybe it looks cumbersome if
it's done in the code, but I still think it's better to
consistenly define symbols like this in CPU byte order
and do the conversions explicitly only when the values
are read/written to "foreign" (external interface)
memory.

Outside of this issue, the remainder of the patch looks
OK to me.

					-Alex

>   /* Channel reset command */
>   #define MHI_TRE_CMD_RESET_PTR (0)
>   #define MHI_TRE_CMD_RESET_DWORD0 (0)
> -#define MHI_TRE_CMD_RESET_DWORD1(chid) ((chid << 24) | \
> -					(MHI_CMD_RESET_CHAN << 16))
> +#define MHI_TRE_CMD_RESET_DWORD1(chid) (cpu_to_le32((chid << 24) | \
> +					(MHI_CMD_RESET_CHAN << 16)))
>   
>   /* Channel stop command */
>   #define MHI_TRE_CMD_STOP_PTR (0)
>   #define MHI_TRE_CMD_STOP_DWORD0 (0)
> -#define MHI_TRE_CMD_STOP_DWORD1(chid) ((chid << 24) | \
> -				       (MHI_CMD_STOP_CHAN << 16))
> +#define MHI_TRE_CMD_STOP_DWORD1(chid) (cpu_to_le32((chid << 24) | \
> +				       (MHI_CMD_STOP_CHAN << 16)))
>   
>   /* Channel start command */
>   #define MHI_TRE_CMD_START_PTR (0)
>   #define MHI_TRE_CMD_START_DWORD0 (0)
> -#define MHI_TRE_CMD_START_DWORD1(chid) ((chid << 24) | \
> -					(MHI_CMD_START_CHAN << 16))
> +#define MHI_TRE_CMD_START_DWORD1(chid) (cpu_to_le32((chid << 24) | \
> +					(MHI_CMD_START_CHAN << 16)))
>   
> -#define MHI_TRE_GET_CMD_CHID(tre) (((tre)->dword[1] >> 24) & 0xFF)
> -#define MHI_TRE_GET_CMD_TYPE(tre) (((tre)->dword[1] >> 16) & 0xFF)
> +#define MHI_TRE_GET_DWORD(tre, word) (le32_to_cpu((tre)->dword[(word)]))
> +#define MHI_TRE_GET_CMD_CHID(tre) ((MHI_TRE_GET_DWORD(tre, 1) >> 24) & 0xFF)
> +#define MHI_TRE_GET_CMD_TYPE(tre) ((MHI_TRE_GET_DWORD(tre, 1) >> 16) & 0xFF)
>   
>   /* Event descriptor macros */
> -#define MHI_TRE_EV_PTR(ptr) (ptr)
> -#define MHI_TRE_EV_DWORD0(code, len) ((code << 24) | len)
> -#define MHI_TRE_EV_DWORD1(chid, type) ((chid << 24) | (type << 16))
> -#define MHI_TRE_GET_EV_PTR(tre) ((tre)->ptr)
> -#define MHI_TRE_GET_EV_CODE(tre) (((tre)->dword[0] >> 24) & 0xFF)
> -#define MHI_TRE_GET_EV_LEN(tre) ((tre)->dword[0] & 0xFFFF)
> -#define MHI_TRE_GET_EV_CHID(tre) (((tre)->dword[1] >> 24) & 0xFF)
> -#define MHI_TRE_GET_EV_TYPE(tre) (((tre)->dword[1] >> 16) & 0xFF)
> -#define MHI_TRE_GET_EV_STATE(tre) (((tre)->dword[0] >> 24) & 0xFF)
> -#define MHI_TRE_GET_EV_EXECENV(tre) (((tre)->dword[0] >> 24) & 0xFF)
> -#define MHI_TRE_GET_EV_SEQ(tre) ((tre)->dword[0])
> -#define MHI_TRE_GET_EV_TIME(tre) ((tre)->ptr)
> -#define MHI_TRE_GET_EV_COOKIE(tre) lower_32_bits((tre)->ptr)
> -#define MHI_TRE_GET_EV_VEID(tre) (((tre)->dword[0] >> 16) & 0xFF)
> -#define MHI_TRE_GET_EV_LINKSPEED(tre) (((tre)->dword[1] >> 24) & 0xFF)
> -#define MHI_TRE_GET_EV_LINKWIDTH(tre) ((tre)->dword[0] & 0xFF)
> +#define MHI_TRE_EV_PTR(ptr) (cpu_to_le64(ptr))
> +#define MHI_TRE_EV_DWORD0(code, len) (cpu_to_le32((code << 24) | len))
> +#define MHI_TRE_EV_DWORD1(chid, type) (cpu_to_le32((chid << 24) | (type << 16)))
> +#define MHI_TRE_GET_EV_PTR(tre) (le64_to_cpu((tre)->ptr))
> +#define MHI_TRE_GET_EV_CODE(tre) ((MHI_TRE_GET_DWORD(tre, 0) >> 24) & 0xFF)
> +#define MHI_TRE_GET_EV_LEN(tre) (MHI_TRE_GET_DWORD(tre, 0) & 0xFFFF)
> +#define MHI_TRE_GET_EV_CHID(tre) ((MHI_TRE_GET_DWORD(tre, 1) >> 24) & 0xFF)
> +#define MHI_TRE_GET_EV_TYPE(tre) ((MHI_TRE_GET_DWORD(tre, 1) >> 16) & 0xFF)
> +#define MHI_TRE_GET_EV_STATE(tre) ((MHI_TRE_GET_DWORD(tre, 0) >> 24) & 0xFF)
> +#define MHI_TRE_GET_EV_EXECENV(tre) ((MHI_TRE_GET_DWORD(tre, 0) >> 24) & 0xFF)
> +#define MHI_TRE_GET_EV_SEQ(tre) MHI_TRE_GET_DWORD(tre, 0)
> +#define MHI_TRE_GET_EV_TIME(tre) (MHI_TRE_GET_EV_PTR(tre))
> +#define MHI_TRE_GET_EV_COOKIE(tre) lower_32_bits(MHI_TRE_GET_EV_PTR(tre))
> +#define MHI_TRE_GET_EV_VEID(tre) ((MHI_TRE_GET_DWORD(tre, 0) >> 16) & 0xFF)
> +#define MHI_TRE_GET_EV_LINKSPEED(tre) ((MHI_TRE_GET_DWORD(tre, 1) >> 24) & 0xFF)
> +#define MHI_TRE_GET_EV_LINKWIDTH(tre) (MHI_TRE_GET_DWORD(tre, 0) & 0xFF)
>   
>   /* Transfer descriptor macros */
> -#define MHI_TRE_DATA_PTR(ptr) (ptr)
> -#define MHI_TRE_DATA_DWORD0(len) (len & MHI_MAX_MTU)
> -#define MHI_TRE_DATA_DWORD1(bei, ieot, ieob, chain) ((2 << 16) | (bei << 10) \
> -	| (ieot << 9) | (ieob << 8) | chain)
> +#define MHI_TRE_DATA_PTR(ptr) (cpu_to_le64(ptr))
> +#define MHI_TRE_DATA_DWORD0(len) (cpu_to_le32(len & MHI_MAX_MTU))
> +#define MHI_TRE_DATA_DWORD1(bei, ieot, ieob, chain) (cpu_to_le32((2 << 16) | (bei << 10) \
> +	| (ieot << 9) | (ieob << 8) | chain))
>   
>   /* RSC transfer descriptor macros */
> -#define MHI_RSCTRE_DATA_PTR(ptr, len) (((u64)len << 48) | ptr)
> -#define MHI_RSCTRE_DATA_DWORD0(cookie) (cookie)
> -#define MHI_RSCTRE_DATA_DWORD1 (MHI_PKT_TYPE_COALESCING << 16)
> +#define MHI_RSCTRE_DATA_PTR(ptr, len) (cpu_to_le64(((u64)len << 48) | ptr))
> +#define MHI_RSCTRE_DATA_DWORD0(cookie) (cpu_to_le32(cookie))
> +#define MHI_RSCTRE_DATA_DWORD1 (cpu_to_le32(MHI_PKT_TYPE_COALESCING << 16))
>   
>   enum mhi_pkt_type {
>   	MHI_PKT_TYPE_INVALID = 0x0,
> @@ -500,7 +501,7 @@ struct state_transition {
>   struct mhi_ring {
>   	dma_addr_t dma_handle;
>   	dma_addr_t iommu_base;
> -	u64 *ctxt_wp; /* point to ctxt wp */
> +	__le64 *ctxt_wp; /* point to ctxt wp */
>   	void *pre_aligned;
>   	void *base;
>   	void *rp;
> diff --git a/drivers/bus/mhi/core/main.c b/drivers/bus/mhi/core/main.c
> index ffde617f93a3..85f4f7c8d7c6 100644
> --- a/drivers/bus/mhi/core/main.c
> +++ b/drivers/bus/mhi/core/main.c
> @@ -114,7 +114,7 @@ void mhi_ring_er_db(struct mhi_event *mhi_event)
>   	struct mhi_ring *ring = &mhi_event->ring;
>   
>   	mhi_event->db_cfg.process_db(mhi_event->mhi_cntrl, &mhi_event->db_cfg,
> -				     ring->db_addr, *ring->ctxt_wp);
> +				     ring->db_addr, le64_to_cpu(*ring->ctxt_wp));
>   }
>   
>   void mhi_ring_cmd_db(struct mhi_controller *mhi_cntrl, struct mhi_cmd *mhi_cmd)
> @@ -123,7 +123,7 @@ void mhi_ring_cmd_db(struct mhi_controller *mhi_cntrl, struct mhi_cmd *mhi_cmd)
>   	struct mhi_ring *ring = &mhi_cmd->ring;
>   
>   	db = ring->iommu_base + (ring->wp - ring->base);
> -	*ring->ctxt_wp = db;
> +	*ring->ctxt_wp = cpu_to_le64(db);
>   	mhi_write_db(mhi_cntrl, ring->db_addr, db);
>   }
>   
> @@ -140,7 +140,7 @@ void mhi_ring_chan_db(struct mhi_controller *mhi_cntrl,
>   	 * before letting h/w know there is new element to fetch.
>   	 */
>   	dma_wmb();
> -	*ring->ctxt_wp = db;
> +	*ring->ctxt_wp = cpu_to_le64(db);
>   
>   	mhi_chan->db_cfg.process_db(mhi_cntrl, &mhi_chan->db_cfg,
>   				    ring->db_addr, db);
> @@ -432,7 +432,7 @@ irqreturn_t mhi_irq_handler(int irq_number, void *dev)
>   	struct mhi_event_ctxt *er_ctxt =
>   		&mhi_cntrl->mhi_ctxt->er_ctxt[mhi_event->er_index];
>   	struct mhi_ring *ev_ring = &mhi_event->ring;
> -	dma_addr_t ptr = er_ctxt->rp;
> +	dma_addr_t ptr = le64_to_cpu(er_ctxt->rp);
>   	void *dev_rp;
>   
>   	if (!is_valid_ring_ptr(ev_ring, ptr)) {
> @@ -537,14 +537,14 @@ static void mhi_recycle_ev_ring_element(struct mhi_controller *mhi_cntrl,
>   
>   	/* Update the WP */
>   	ring->wp += ring->el_size;
> -	ctxt_wp = *ring->ctxt_wp + ring->el_size;
> +	ctxt_wp = le64_to_cpu(*ring->ctxt_wp) + ring->el_size;
>   
>   	if (ring->wp >= (ring->base + ring->len)) {
>   		ring->wp = ring->base;
>   		ctxt_wp = ring->iommu_base;
>   	}
>   
> -	*ring->ctxt_wp = ctxt_wp;
> +	*ring->ctxt_wp = cpu_to_le64(ctxt_wp);
>   
>   	/* Update the RP */
>   	ring->rp += ring->el_size;
> @@ -801,7 +801,7 @@ int mhi_process_ctrl_ev_ring(struct mhi_controller *mhi_cntrl,
>   	struct device *dev = &mhi_cntrl->mhi_dev->dev;
>   	u32 chan;
>   	int count = 0;
> -	dma_addr_t ptr = er_ctxt->rp;
> +	dma_addr_t ptr = le64_to_cpu(er_ctxt->rp);
>   
>   	/*
>   	 * This is a quick check to avoid unnecessary event processing
> @@ -940,7 +940,7 @@ int mhi_process_ctrl_ev_ring(struct mhi_controller *mhi_cntrl,
>   		mhi_recycle_ev_ring_element(mhi_cntrl, ev_ring);
>   		local_rp = ev_ring->rp;
>   
> -		ptr = er_ctxt->rp;
> +		ptr = le64_to_cpu(er_ctxt->rp);
>   		if (!is_valid_ring_ptr(ev_ring, ptr)) {
>   			dev_err(&mhi_cntrl->mhi_dev->dev,
>   				"Event ring rp points outside of the event ring\n");
> @@ -970,7 +970,7 @@ int mhi_process_data_event_ring(struct mhi_controller *mhi_cntrl,
>   	int count = 0;
>   	u32 chan;
>   	struct mhi_chan *mhi_chan;
> -	dma_addr_t ptr = er_ctxt->rp;
> +	dma_addr_t ptr = le64_to_cpu(er_ctxt->rp);
>   
>   	if (unlikely(MHI_EVENT_ACCESS_INVALID(mhi_cntrl->pm_state)))
>   		return -EIO;
> @@ -1011,7 +1011,7 @@ int mhi_process_data_event_ring(struct mhi_controller *mhi_cntrl,
>   		mhi_recycle_ev_ring_element(mhi_cntrl, ev_ring);
>   		local_rp = ev_ring->rp;
>   
> -		ptr = er_ctxt->rp;
> +		ptr = le64_to_cpu(er_ctxt->rp);
>   		if (!is_valid_ring_ptr(ev_ring, ptr)) {
>   			dev_err(&mhi_cntrl->mhi_dev->dev,
>   				"Event ring rp points outside of the event ring\n");
> @@ -1533,7 +1533,7 @@ static void mhi_mark_stale_events(struct mhi_controller *mhi_cntrl,
>   	/* mark all stale events related to channel as STALE event */
>   	spin_lock_irqsave(&mhi_event->lock, flags);
>   
> -	ptr = er_ctxt->rp;
> +	ptr = le64_to_cpu(er_ctxt->rp);
>   	if (!is_valid_ring_ptr(ev_ring, ptr)) {
>   		dev_err(&mhi_cntrl->mhi_dev->dev,
>   			"Event ring rp points outside of the event ring\n");
> diff --git a/drivers/bus/mhi/core/pm.c b/drivers/bus/mhi/core/pm.c
> index 4aae0baea008..c35c5ddc7220 100644
> --- a/drivers/bus/mhi/core/pm.c
> +++ b/drivers/bus/mhi/core/pm.c
> @@ -218,7 +218,7 @@ int mhi_ready_state_transition(struct mhi_controller *mhi_cntrl)
>   			continue;
>   
>   		ring->wp = ring->base + ring->len - ring->el_size;
> -		*ring->ctxt_wp = ring->iommu_base + ring->len - ring->el_size;
> +		*ring->ctxt_wp = cpu_to_le64(ring->iommu_base + ring->len - ring->el_size);
>   		/* Update all cores */
>   		smp_wmb();
>   
> @@ -420,7 +420,7 @@ static int mhi_pm_mission_mode_transition(struct mhi_controller *mhi_cntrl)
>   			continue;
>   
>   		ring->wp = ring->base + ring->len - ring->el_size;
> -		*ring->ctxt_wp = ring->iommu_base + ring->len - ring->el_size;
> +		*ring->ctxt_wp = cpu_to_le64(ring->iommu_base + ring->len - ring->el_size);
>   		/* Update to all cores */
>   		smp_wmb();
>   

