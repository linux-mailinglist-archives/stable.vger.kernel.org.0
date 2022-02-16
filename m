Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 851584B8B6A
	for <lists+stable@lfdr.de>; Wed, 16 Feb 2022 15:29:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235018AbiBPOaB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Feb 2022 09:30:01 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:47646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235014AbiBPOaB (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Feb 2022 09:30:01 -0500
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF5F1293B5F
        for <stable@vger.kernel.org>; Wed, 16 Feb 2022 06:29:47 -0800 (PST)
Received: by mail-io1-xd31.google.com with SMTP id e79so2395968iof.13
        for <stable@vger.kernel.org>; Wed, 16 Feb 2022 06:29:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=8v5HTH39+llRa90u3U656HBQtObKv83Qz/IBi0xDrdw=;
        b=xCiJQt+Iumfr5KfaOa1r2b0Lg2hAahk3LdijSDyQLXi/XSMT0dinF1pMJIkbIQu88l
         +te4uy9oLIFVedf6nF5nCc9IgoGvqAh7xBxDFdE0564B7QH/3+usql/iogzzViX50XL5
         oNgM2gxKURCMWmITCpjie9/th33j87m/uVX49IiwI9eKLOwuWYYajOzIZQs8eldvvDh9
         0gRhEkSvDJUPcOzYjOOUpG9ZvEQl9NJ5UbMSkEDL+oM/tMCM0DpDPRl1eHdzsCakD2hl
         vqwG9vIYpBbXWlxAGkv0d2m+4ZbpWcxcB/zkKwqCvMBF1JyLggeZx2yUFVvdjFX9YL9B
         RtUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=8v5HTH39+llRa90u3U656HBQtObKv83Qz/IBi0xDrdw=;
        b=7wKfbLqU0ea0jDHY88y/UlPyTu3/Fri0Q+VLqmU2fSP7FWi++DEdliZTmUHusYFUVz
         gDU9johOjLtF1CwllQKu5qncOI3nPGdMyiNrZ9MNEliSnta6gyQKNTtTUITlkgt+AMXe
         21fNBI9MniR0T4Lhf2pmo5WiQk0VRKu9xnDL+bQ3Mu07uAx4eCTsHmbctG7jJ7VVCLbU
         fQ8fXqVYpANzxI80XYfR2Vg48zsCMVsLkNDy/+XBpdv47iZ3/GSDoECmZcqo5agfaqsw
         x5os3DbhtivuAFgOmuXQf7ggDLNBqaEOG4zBlpaFo4flzsf+9bebobivhWDFdRCqqGug
         rKiQ==
X-Gm-Message-State: AOAM530OAoRDcy0BUt/th86kckps9Mgc33lXOhu/Uek3Cb89dyq2VWZI
        bCduRC9Rn+yeQISb7FHTHz/iDg==
X-Google-Smtp-Source: ABdhPJyrUHvHZhBy3WVqJxOJk3l0PbUlId4c4S4OPZqFRn8tpIaUdls6FsO2LBoDoBlhPj/+bFEhrA==
X-Received: by 2002:a05:6602:1594:b0:638:d61e:310e with SMTP id e20-20020a056602159400b00638d61e310emr1961432iow.165.1645021786881;
        Wed, 16 Feb 2022 06:29:46 -0800 (PST)
Received: from [172.22.22.4] (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.googlemail.com with ESMTPSA id i15sm26226274iog.14.2022.02.16.06.29.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Feb 2022 06:29:46 -0800 (PST)
Message-ID: <66691793-1313-3422-a98f-9a6603cc3ce0@linaro.org>
Date:   Wed, 16 Feb 2022 08:29:44 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v3 02/25] bus: mhi: Fix MHI DMA structure endianness
Content-Language: en-US
To:     Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Cc:     mhi@lists.linux.dev, quic_hemantk@quicinc.com,
        quic_bbhatt@quicinc.com, quic_jhugo@quicinc.com,
        vinod.koul@linaro.org, bjorn.andersson@linaro.org,
        dmitry.baryshkov@linaro.org, quic_vbadigan@quicinc.com,
        quic_cang@quicinc.com, quic_skananth@quicinc.com,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paul Davey <paul.davey@alliedtelesis.co.nz>,
        stable@vger.kernel.org
References: <20220212182117.49438-1-manivannan.sadhasivam@linaro.org>
 <20220212182117.49438-3-manivannan.sadhasivam@linaro.org>
 <2ddfa2c9-0e03-e4f7-e0e5-78230bef43fe@linaro.org>
 <20220216070424.GA6225@workstation>
From:   Alex Elder <elder@linaro.org>
In-Reply-To: <20220216070424.GA6225@workstation>
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

On 2/16/22 1:04 AM, Manivannan Sadhasivam wrote:
> On Tue, Feb 15, 2022 at 02:02:01PM -0600, Alex Elder wrote:
>> On 2/12/22 12:20 PM, Manivannan Sadhasivam wrote:
>>> From: Paul Davey <paul.davey@alliedtelesis.co.nz>
>>>
>>> The MHI driver does not work on big endian architectures.  The
>>> controller never transitions into mission mode.  This appears to be due
>>> to the modem device expecting the various contexts and transfer rings to
>>> have fields in little endian order in memory, but the driver constructs
>>> them in native endianness.
>>
>> Yes, this is true.
>>
>>> Fix MHI event, channel and command contexts and TRE handling macros to
>>> use explicit conversion to little endian.  Mark fields in relevant
>>> structures as little endian to document this requirement.
>>
>> Basically every field in the external interface whose size
>> is greater than one byte must have its endianness noted.
>>  From what I can tell, you did that for all of the exposed
>> structures defined in "drivers/bus/mhi/core/internal.h",
>> which is good.
>>
>> *However* some of the *constants* were defined the wrong way.
>>
>> Basically, all of the constant values should be expressed
>> in host byte order.  And any needed byte swapping should be
>> done at the time the value is read from memory--immediately.
>> That way, we isolate that activity to the one place we
>> interface with the possibly "foreign" format, and from then
>> on, everything may be assumed to be in natural (CPU) byte order.
>>
> 
> Well, I did think about it but I convinced myself that doing the
> conversion in code rather in defines make the code look messy.
> Also in some places it just makes it look complicated. More below:

I thought this might the case.

>> I will point out what I mean, below.
>>
>>> Fixes: a6e2e3522f29 ("bus: mhi: core: Add support for PM state transitions")
>>> Fixes: 6cd330ae76ff ("bus: mhi: core: Add support for ringing channel/event ring doorbells")
>>> Signed-off-by: Paul Davey <paul.davey@alliedtelesis.co.nz>
>>> Cc: stable@vger.kernel.org
>>> Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
>>> ---
>>>    drivers/bus/mhi/core/debugfs.c  |  26 +++----
>>>    drivers/bus/mhi/core/init.c     |  36 +++++-----
>>>    drivers/bus/mhi/core/internal.h | 119 ++++++++++++++++----------------
>>>    drivers/bus/mhi/core/main.c     |  22 +++---
>>>    drivers/bus/mhi/core/pm.c       |   4 +-
>>>    5 files changed, 104 insertions(+), 103 deletions(-)
>>>
> 
> [...]
> 
>>> @@ -277,57 +277,58 @@ enum mhi_cmd_type {
>>>    /* No operation command */
>>>    #define MHI_TRE_CMD_NOOP_PTR (0)
>>>    #define MHI_TRE_CMD_NOOP_DWORD0 (0)
>>> -#define MHI_TRE_CMD_NOOP_DWORD1 (MHI_CMD_NOP << 16)
>>> +#define MHI_TRE_CMD_NOOP_DWORD1 (cpu_to_le32(MHI_CMD_NOP << 16))
>>
>> This just looks wrong to me.  The original definition
>> should be fine, but then where it's *used* it should
>> be passed to cpu_to_le32().  I realize this might be
>> a special case, where these "DWORD" values are getting
>> written out to command ring elements, but even so, the
>> byte swapping that's happening is important and should
>> be made obvious in the code using these symbols.
>>
>> This comment applies to many more similar definitions
>> below.  I don't know; maybe it looks cumbersome if
>> it's done in the code, but I still think it's better to
>> consistenly define symbols like this in CPU byte order
>> and do the conversions explicitly only when the values
>> are read/written to "foreign" (external interface)
>> memory.
>>
> 
> Defines like MHI_TRE_GET_CMD_CHID are making the conversion look messy
> to me. In this we first extract the DWORD from TRE and then doing
> shifting + masking to get the CHID.

I didn't say so, but I don't really like those defines either.
I personally would rather see the field values get extracted
in open code rather than this, because they're actually pretty
simple operations.  But I understand, sometimes things just
"look complicated" if you do them certain ways (even if simple).

I did it in a certain way in the IPA code and I find that
preferable to the use of the "DWORD" definitions you're
using.  I also stand by my belief that it's preferable to
not hide the byte swaps in macro definitions.

You use this for reading/writing the command/transfer/event
ring elements (only) though, and you do that consistently.

> So without splitting the DWORD extraction and GET_CHID macros
> separately, we can't just do the conversion in code. And we may end up
> doing the conversion in defines just for these special cases but that
> will break the uniformity.
> 
> So IMO it looks better if we trust the defines to do the conversion itself.
> 
> Please let me know if you think the other way.

I'm OK with it.  I'm not convinced, but I won't object...

					-Alex

> 
> Thanks,
> Mani
> 
>> Outside of this issue, the remainder of the patch looks
>> OK to me.
>>
>> 					-Alex
>>
>>>    /* Channel reset command */
>>>    #define MHI_TRE_CMD_RESET_PTR (0)
>>>    #define MHI_TRE_CMD_RESET_DWORD0 (0)
>>> -#define MHI_TRE_CMD_RESET_DWORD1(chid) ((chid << 24) | \
>>> -					(MHI_CMD_RESET_CHAN << 16))
>>> +#define MHI_TRE_CMD_RESET_DWORD1(chid) (cpu_to_le32((chid << 24) | \
>>> +					(MHI_CMD_RESET_CHAN << 16)))
>>>    /* Channel stop command */
>>>    #define MHI_TRE_CMD_STOP_PTR (0)
>>>    #define MHI_TRE_CMD_STOP_DWORD0 (0)
>>> -#define MHI_TRE_CMD_STOP_DWORD1(chid) ((chid << 24) | \
>>> -				       (MHI_CMD_STOP_CHAN << 16))
>>> +#define MHI_TRE_CMD_STOP_DWORD1(chid) (cpu_to_le32((chid << 24) | \
>>> +				       (MHI_CMD_STOP_CHAN << 16)))
>>>    /* Channel start command */
>>>    #define MHI_TRE_CMD_START_PTR (0)
>>>    #define MHI_TRE_CMD_START_DWORD0 (0)
>>> -#define MHI_TRE_CMD_START_DWORD1(chid) ((chid << 24) | \
>>> -					(MHI_CMD_START_CHAN << 16))
>>> +#define MHI_TRE_CMD_START_DWORD1(chid) (cpu_to_le32((chid << 24) | \
>>> +					(MHI_CMD_START_CHAN << 16)))
>>> -#define MHI_TRE_GET_CMD_CHID(tre) (((tre)->dword[1] >> 24) & 0xFF)
>>> -#define MHI_TRE_GET_CMD_TYPE(tre) (((tre)->dword[1] >> 16) & 0xFF)
>>> +#define MHI_TRE_GET_DWORD(tre, word) (le32_to_cpu((tre)->dword[(word)]))
>>> +#define MHI_TRE_GET_CMD_CHID(tre) ((MHI_TRE_GET_DWORD(tre, 1) >> 24) & 0xFF)
>>> +#define MHI_TRE_GET_CMD_TYPE(tre) ((MHI_TRE_GET_DWORD(tre, 1) >> 16) & 0xFF)
>>>    /* Event descriptor macros */
>>> -#define MHI_TRE_EV_PTR(ptr) (ptr)
>>> -#define MHI_TRE_EV_DWORD0(code, len) ((code << 24) | len)
>>> -#define MHI_TRE_EV_DWORD1(chid, type) ((chid << 24) | (type << 16))
>>> -#define MHI_TRE_GET_EV_PTR(tre) ((tre)->ptr)
>>> -#define MHI_TRE_GET_EV_CODE(tre) (((tre)->dword[0] >> 24) & 0xFF)
>>> -#define MHI_TRE_GET_EV_LEN(tre) ((tre)->dword[0] & 0xFFFF)
>>> -#define MHI_TRE_GET_EV_CHID(tre) (((tre)->dword[1] >> 24) & 0xFF)
>>> -#define MHI_TRE_GET_EV_TYPE(tre) (((tre)->dword[1] >> 16) & 0xFF)
>>> -#define MHI_TRE_GET_EV_STATE(tre) (((tre)->dword[0] >> 24) & 0xFF)
>>> -#define MHI_TRE_GET_EV_EXECENV(tre) (((tre)->dword[0] >> 24) & 0xFF)
>>> -#define MHI_TRE_GET_EV_SEQ(tre) ((tre)->dword[0])
>>> -#define MHI_TRE_GET_EV_TIME(tre) ((tre)->ptr)
>>> -#define MHI_TRE_GET_EV_COOKIE(tre) lower_32_bits((tre)->ptr)
>>> -#define MHI_TRE_GET_EV_VEID(tre) (((tre)->dword[0] >> 16) & 0xFF)
>>> -#define MHI_TRE_GET_EV_LINKSPEED(tre) (((tre)->dword[1] >> 24) & 0xFF)
>>> -#define MHI_TRE_GET_EV_LINKWIDTH(tre) ((tre)->dword[0] & 0xFF)
>>> +#define MHI_TRE_EV_PTR(ptr) (cpu_to_le64(ptr))
>>> +#define MHI_TRE_EV_DWORD0(code, len) (cpu_to_le32((code << 24) | len))
>>> +#define MHI_TRE_EV_DWORD1(chid, type) (cpu_to_le32((chid << 24) | (type << 16)))
>>> +#define MHI_TRE_GET_EV_PTR(tre) (le64_to_cpu((tre)->ptr))
>>> +#define MHI_TRE_GET_EV_CODE(tre) ((MHI_TRE_GET_DWORD(tre, 0) >> 24) & 0xFF)
>>> +#define MHI_TRE_GET_EV_LEN(tre) (MHI_TRE_GET_DWORD(tre, 0) & 0xFFFF)
>>> +#define MHI_TRE_GET_EV_CHID(tre) ((MHI_TRE_GET_DWORD(tre, 1) >> 24) & 0xFF)
>>> +#define MHI_TRE_GET_EV_TYPE(tre) ((MHI_TRE_GET_DWORD(tre, 1) >> 16) & 0xFF)
>>> +#define MHI_TRE_GET_EV_STATE(tre) ((MHI_TRE_GET_DWORD(tre, 0) >> 24) & 0xFF)
>>> +#define MHI_TRE_GET_EV_EXECENV(tre) ((MHI_TRE_GET_DWORD(tre, 0) >> 24) & 0xFF)
>>> +#define MHI_TRE_GET_EV_SEQ(tre) MHI_TRE_GET_DWORD(tre, 0)
>>> +#define MHI_TRE_GET_EV_TIME(tre) (MHI_TRE_GET_EV_PTR(tre))
>>> +#define MHI_TRE_GET_EV_COOKIE(tre) lower_32_bits(MHI_TRE_GET_EV_PTR(tre))
>>> +#define MHI_TRE_GET_EV_VEID(tre) ((MHI_TRE_GET_DWORD(tre, 0) >> 16) & 0xFF)
>>> +#define MHI_TRE_GET_EV_LINKSPEED(tre) ((MHI_TRE_GET_DWORD(tre, 1) >> 24) & 0xFF)
>>> +#define MHI_TRE_GET_EV_LINKWIDTH(tre) (MHI_TRE_GET_DWORD(tre, 0) & 0xFF)
>>>    /* Transfer descriptor macros */
>>> -#define MHI_TRE_DATA_PTR(ptr) (ptr)
>>> -#define MHI_TRE_DATA_DWORD0(len) (len & MHI_MAX_MTU)
>>> -#define MHI_TRE_DATA_DWORD1(bei, ieot, ieob, chain) ((2 << 16) | (bei << 10) \
>>> -	| (ieot << 9) | (ieob << 8) | chain)
>>> +#define MHI_TRE_DATA_PTR(ptr) (cpu_to_le64(ptr))
>>> +#define MHI_TRE_DATA_DWORD0(len) (cpu_to_le32(len & MHI_MAX_MTU))
>>> +#define MHI_TRE_DATA_DWORD1(bei, ieot, ieob, chain) (cpu_to_le32((2 << 16) | (bei << 10) \
>>> +	| (ieot << 9) | (ieob << 8) | chain))
>>>    /* RSC transfer descriptor macros */
>>> -#define MHI_RSCTRE_DATA_PTR(ptr, len) (((u64)len << 48) | ptr)
>>> -#define MHI_RSCTRE_DATA_DWORD0(cookie) (cookie)
>>> -#define MHI_RSCTRE_DATA_DWORD1 (MHI_PKT_TYPE_COALESCING << 16)
>>> +#define MHI_RSCTRE_DATA_PTR(ptr, len) (cpu_to_le64(((u64)len << 48) | ptr))
>>> +#define MHI_RSCTRE_DATA_DWORD0(cookie) (cpu_to_le32(cookie))
>>> +#define MHI_RSCTRE_DATA_DWORD1 (cpu_to_le32(MHI_PKT_TYPE_COALESCING << 16))
>>>    enum mhi_pkt_type {
>>>    	MHI_PKT_TYPE_INVALID = 0x0,
>>> @@ -500,7 +501,7 @@ struct state_transition {
>>>    struct mhi_ring {
>>>    	dma_addr_t dma_handle;
>>>    	dma_addr_t iommu_base;
>>> -	u64 *ctxt_wp; /* point to ctxt wp */
>>> +	__le64 *ctxt_wp; /* point to ctxt wp */
>>>    	void *pre_aligned;
>>>    	void *base;
>>>    	void *rp;
>>> diff --git a/drivers/bus/mhi/core/main.c b/drivers/bus/mhi/core/main.c
>>> index ffde617f93a3..85f4f7c8d7c6 100644
>>> --- a/drivers/bus/mhi/core/main.c
>>> +++ b/drivers/bus/mhi/core/main.c
>>> @@ -114,7 +114,7 @@ void mhi_ring_er_db(struct mhi_event *mhi_event)
>>>    	struct mhi_ring *ring = &mhi_event->ring;
>>>    	mhi_event->db_cfg.process_db(mhi_event->mhi_cntrl, &mhi_event->db_cfg,
>>> -				     ring->db_addr, *ring->ctxt_wp);
>>> +				     ring->db_addr, le64_to_cpu(*ring->ctxt_wp));
>>>    }
>>>    void mhi_ring_cmd_db(struct mhi_controller *mhi_cntrl, struct mhi_cmd *mhi_cmd)
>>> @@ -123,7 +123,7 @@ void mhi_ring_cmd_db(struct mhi_controller *mhi_cntrl, struct mhi_cmd *mhi_cmd)
>>>    	struct mhi_ring *ring = &mhi_cmd->ring;
>>>    	db = ring->iommu_base + (ring->wp - ring->base);
>>> -	*ring->ctxt_wp = db;
>>> +	*ring->ctxt_wp = cpu_to_le64(db);
>>>    	mhi_write_db(mhi_cntrl, ring->db_addr, db);
>>>    }
>>> @@ -140,7 +140,7 @@ void mhi_ring_chan_db(struct mhi_controller *mhi_cntrl,
>>>    	 * before letting h/w know there is new element to fetch.
>>>    	 */
>>>    	dma_wmb();
>>> -	*ring->ctxt_wp = db;
>>> +	*ring->ctxt_wp = cpu_to_le64(db);
>>>    	mhi_chan->db_cfg.process_db(mhi_cntrl, &mhi_chan->db_cfg,
>>>    				    ring->db_addr, db);
>>> @@ -432,7 +432,7 @@ irqreturn_t mhi_irq_handler(int irq_number, void *dev)
>>>    	struct mhi_event_ctxt *er_ctxt =
>>>    		&mhi_cntrl->mhi_ctxt->er_ctxt[mhi_event->er_index];
>>>    	struct mhi_ring *ev_ring = &mhi_event->ring;
>>> -	dma_addr_t ptr = er_ctxt->rp;
>>> +	dma_addr_t ptr = le64_to_cpu(er_ctxt->rp);
>>>    	void *dev_rp;
>>>    	if (!is_valid_ring_ptr(ev_ring, ptr)) {
>>> @@ -537,14 +537,14 @@ static void mhi_recycle_ev_ring_element(struct mhi_controller *mhi_cntrl,
>>>    	/* Update the WP */
>>>    	ring->wp += ring->el_size;
>>> -	ctxt_wp = *ring->ctxt_wp + ring->el_size;
>>> +	ctxt_wp = le64_to_cpu(*ring->ctxt_wp) + ring->el_size;
>>>    	if (ring->wp >= (ring->base + ring->len)) {
>>>    		ring->wp = ring->base;
>>>    		ctxt_wp = ring->iommu_base;
>>>    	}
>>> -	*ring->ctxt_wp = ctxt_wp;
>>> +	*ring->ctxt_wp = cpu_to_le64(ctxt_wp);
>>>    	/* Update the RP */
>>>    	ring->rp += ring->el_size;
>>> @@ -801,7 +801,7 @@ int mhi_process_ctrl_ev_ring(struct mhi_controller *mhi_cntrl,
>>>    	struct device *dev = &mhi_cntrl->mhi_dev->dev;
>>>    	u32 chan;
>>>    	int count = 0;
>>> -	dma_addr_t ptr = er_ctxt->rp;
>>> +	dma_addr_t ptr = le64_to_cpu(er_ctxt->rp);
>>>    	/*
>>>    	 * This is a quick check to avoid unnecessary event processing
>>> @@ -940,7 +940,7 @@ int mhi_process_ctrl_ev_ring(struct mhi_controller *mhi_cntrl,
>>>    		mhi_recycle_ev_ring_element(mhi_cntrl, ev_ring);
>>>    		local_rp = ev_ring->rp;
>>> -		ptr = er_ctxt->rp;
>>> +		ptr = le64_to_cpu(er_ctxt->rp);
>>>    		if (!is_valid_ring_ptr(ev_ring, ptr)) {
>>>    			dev_err(&mhi_cntrl->mhi_dev->dev,
>>>    				"Event ring rp points outside of the event ring\n");
>>> @@ -970,7 +970,7 @@ int mhi_process_data_event_ring(struct mhi_controller *mhi_cntrl,
>>>    	int count = 0;
>>>    	u32 chan;
>>>    	struct mhi_chan *mhi_chan;
>>> -	dma_addr_t ptr = er_ctxt->rp;
>>> +	dma_addr_t ptr = le64_to_cpu(er_ctxt->rp);
>>>    	if (unlikely(MHI_EVENT_ACCESS_INVALID(mhi_cntrl->pm_state)))
>>>    		return -EIO;
>>> @@ -1011,7 +1011,7 @@ int mhi_process_data_event_ring(struct mhi_controller *mhi_cntrl,
>>>    		mhi_recycle_ev_ring_element(mhi_cntrl, ev_ring);
>>>    		local_rp = ev_ring->rp;
>>> -		ptr = er_ctxt->rp;
>>> +		ptr = le64_to_cpu(er_ctxt->rp);
>>>    		if (!is_valid_ring_ptr(ev_ring, ptr)) {
>>>    			dev_err(&mhi_cntrl->mhi_dev->dev,
>>>    				"Event ring rp points outside of the event ring\n");
>>> @@ -1533,7 +1533,7 @@ static void mhi_mark_stale_events(struct mhi_controller *mhi_cntrl,
>>>    	/* mark all stale events related to channel as STALE event */
>>>    	spin_lock_irqsave(&mhi_event->lock, flags);
>>> -	ptr = er_ctxt->rp;
>>> +	ptr = le64_to_cpu(er_ctxt->rp);
>>>    	if (!is_valid_ring_ptr(ev_ring, ptr)) {
>>>    		dev_err(&mhi_cntrl->mhi_dev->dev,
>>>    			"Event ring rp points outside of the event ring\n");
>>> diff --git a/drivers/bus/mhi/core/pm.c b/drivers/bus/mhi/core/pm.c
>>> index 4aae0baea008..c35c5ddc7220 100644
>>> --- a/drivers/bus/mhi/core/pm.c
>>> +++ b/drivers/bus/mhi/core/pm.c
>>> @@ -218,7 +218,7 @@ int mhi_ready_state_transition(struct mhi_controller *mhi_cntrl)
>>>    			continue;
>>>    		ring->wp = ring->base + ring->len - ring->el_size;
>>> -		*ring->ctxt_wp = ring->iommu_base + ring->len - ring->el_size;
>>> +		*ring->ctxt_wp = cpu_to_le64(ring->iommu_base + ring->len - ring->el_size);
>>>    		/* Update all cores */
>>>    		smp_wmb();
>>> @@ -420,7 +420,7 @@ static int mhi_pm_mission_mode_transition(struct mhi_controller *mhi_cntrl)
>>>    			continue;
>>>    		ring->wp = ring->base + ring->len - ring->el_size;
>>> -		*ring->ctxt_wp = ring->iommu_base + ring->len - ring->el_size;
>>> +		*ring->ctxt_wp = cpu_to_le64(ring->iommu_base + ring->len - ring->el_size);
>>>    		/* Update to all cores */
>>>    		smp_wmb();
>>

