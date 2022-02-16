Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9F9B4B80EE
	for <lists+stable@lfdr.de>; Wed, 16 Feb 2022 08:08:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229618AbiBPHHf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Feb 2022 02:07:35 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:34246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbiBPHH2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Feb 2022 02:07:28 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B101C256ED5
        for <stable@vger.kernel.org>; Tue, 15 Feb 2022 23:06:42 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id 10so1330462plj.1
        for <stable@vger.kernel.org>; Tue, 15 Feb 2022 23:06:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=1gUe7cNWWp5jPSyyMpftZXbqEu5b63DOSsVxveCq2ps=;
        b=YhhVuKCFyI88R7IDLGbF3CCuBuXJHPwiMtygUFF2fAj5ktD8iBNf8Pf8twO3WsUvH6
         +DjNim9Fqz6pmCZnL8/ffg2aP8Cgol13mFhdBMS0Unj5MZeDcwWGMfNNwIZ/1Tw/t8xb
         CqxLPXowrcghODk5fAovPVXGa+Vga4RpdpBrBy0EyH0U12t/iwT853h8V/U8RlVHpnOO
         dHvnoBc0x6HxLaGsaTa4IVwe4+nyrMs81AhDfERVVqz4NcVGDolX1J4ryaKnSe0AuCa0
         WOZM11ujyL5xNAPUtTA8xViyLYHEKX7ZrYmZ/HFrfwhlPH1jf/oQ6azrGh8BwuIColne
         Y0ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=1gUe7cNWWp5jPSyyMpftZXbqEu5b63DOSsVxveCq2ps=;
        b=usqkRrtrWgx1mDcFO/l3fimHvpge/r2N0n5HAaShWqSWVKL9grMVlZrEU5tNJKZafu
         MeekGvjpnjs/eIB66IsBZy2/rUc2nTSNnzLoRGSIhFxe8nW3V+8o8CSao8vXCNcP/ibc
         lXHvou9RqGu5ejDINKDCifqNH8WNCmQ/60L8svwmbG+3Ww+cFB0HOYgvszw7nGLoc3/1
         aXn8wZ/p42bWw1abZ1uSda9vb+sWpWDMRg/GAnK7SKp89KmBp3AqlDr8cDHOBrhMZL+K
         RINLFNr71475NKjyI9FD/4VL34Ot3h9O2cWL6KrHhxTZ67H1iI1Bi+HQgs8o3yMEWTtv
         pu8w==
X-Gm-Message-State: AOAM530U3IanM2wUOmmSu87lrBDYdUBuUG9kvxsXYzSe7+l5jgFssa/Q
        cwm7CkAdYFmhlXD+0G/XkpYi
X-Google-Smtp-Source: ABdhPJyd2T4i7KV4O+k8PTpsysusmBElWwsfEQJ8CzBHSFSmMz8TmlqmEnn9P+3VQ1x+bunGMW6qbQ==
X-Received: by 2002:a17:90b:f0c:b0:1b9:c6b7:7cd6 with SMTP id br12-20020a17090b0f0c00b001b9c6b77cd6mr187155pjb.231.1644995070475;
        Tue, 15 Feb 2022 23:04:30 -0800 (PST)
Received: from workstation ([117.193.208.189])
        by smtp.gmail.com with ESMTPSA id c14sm40572968pfm.169.2022.02.15.23.04.26
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 15 Feb 2022 23:04:29 -0800 (PST)
Date:   Wed, 16 Feb 2022 12:34:24 +0530
From:   Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To:     Alex Elder <elder@linaro.org>
Cc:     mhi@lists.linux.dev, quic_hemantk@quicinc.com,
        quic_bbhatt@quicinc.com, quic_jhugo@quicinc.com,
        vinod.koul@linaro.org, bjorn.andersson@linaro.org,
        dmitry.baryshkov@linaro.org, quic_vbadigan@quicinc.com,
        quic_cang@quicinc.com, quic_skananth@quicinc.com,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paul Davey <paul.davey@alliedtelesis.co.nz>,
        stable@vger.kernel.org
Subject: Re: [PATCH v3 02/25] bus: mhi: Fix MHI DMA structure endianness
Message-ID: <20220216070424.GA6225@workstation>
References: <20220212182117.49438-1-manivannan.sadhasivam@linaro.org>
 <20220212182117.49438-3-manivannan.sadhasivam@linaro.org>
 <2ddfa2c9-0e03-e4f7-e0e5-78230bef43fe@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2ddfa2c9-0e03-e4f7-e0e5-78230bef43fe@linaro.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 15, 2022 at 02:02:01PM -0600, Alex Elder wrote:
> On 2/12/22 12:20 PM, Manivannan Sadhasivam wrote:
> > From: Paul Davey <paul.davey@alliedtelesis.co.nz>
> > 
> > The MHI driver does not work on big endian architectures.  The
> > controller never transitions into mission mode.  This appears to be due
> > to the modem device expecting the various contexts and transfer rings to
> > have fields in little endian order in memory, but the driver constructs
> > them in native endianness.
> 
> Yes, this is true.
> 
> > Fix MHI event, channel and command contexts and TRE handling macros to
> > use explicit conversion to little endian.  Mark fields in relevant
> > structures as little endian to document this requirement.
> 
> Basically every field in the external interface whose size
> is greater than one byte must have its endianness noted.
> From what I can tell, you did that for all of the exposed
> structures defined in "drivers/bus/mhi/core/internal.h",
> which is good.
> 
> *However* some of the *constants* were defined the wrong way.
> 
> Basically, all of the constant values should be expressed
> in host byte order.  And any needed byte swapping should be
> done at the time the value is read from memory--immediately.
> That way, we isolate that activity to the one place we
> interface with the possibly "foreign" format, and from then
> on, everything may be assumed to be in natural (CPU) byte order.
> 

Well, I did think about it but I convinced myself that doing the
conversion in code rather in defines make the code look messy.
Also in some places it just makes it look complicated. More below:

> I will point out what I mean, below.
> 
> > Fixes: a6e2e3522f29 ("bus: mhi: core: Add support for PM state transitions")
> > Fixes: 6cd330ae76ff ("bus: mhi: core: Add support for ringing channel/event ring doorbells")
> > Signed-off-by: Paul Davey <paul.davey@alliedtelesis.co.nz>
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
> > ---
> >   drivers/bus/mhi/core/debugfs.c  |  26 +++----
> >   drivers/bus/mhi/core/init.c     |  36 +++++-----
> >   drivers/bus/mhi/core/internal.h | 119 ++++++++++++++++----------------
> >   drivers/bus/mhi/core/main.c     |  22 +++---
> >   drivers/bus/mhi/core/pm.c       |   4 +-
> >   5 files changed, 104 insertions(+), 103 deletions(-)
> > 

[...]

> > @@ -277,57 +277,58 @@ enum mhi_cmd_type {
> >   /* No operation command */
> >   #define MHI_TRE_CMD_NOOP_PTR (0)
> >   #define MHI_TRE_CMD_NOOP_DWORD0 (0)
> > -#define MHI_TRE_CMD_NOOP_DWORD1 (MHI_CMD_NOP << 16)
> > +#define MHI_TRE_CMD_NOOP_DWORD1 (cpu_to_le32(MHI_CMD_NOP << 16))
> 
> This just looks wrong to me.  The original definition
> should be fine, but then where it's *used* it should
> be passed to cpu_to_le32().  I realize this might be
> a special case, where these "DWORD" values are getting
> written out to command ring elements, but even so, the
> byte swapping that's happening is important and should
> be made obvious in the code using these symbols.
> 
> This comment applies to many more similar definitions
> below.  I don't know; maybe it looks cumbersome if
> it's done in the code, but I still think it's better to
> consistenly define symbols like this in CPU byte order
> and do the conversions explicitly only when the values
> are read/written to "foreign" (external interface)
> memory.
> 

Defines like MHI_TRE_GET_CMD_CHID are making the conversion look messy
to me. In this we first extract the DWORD from TRE and then doing
shifting + masking to get the CHID.

So without splitting the DWORD extraction and GET_CHID macros
separately, we can't just do the conversion in code. And we may end up
doing the conversion in defines just for these special cases but that
will break the uniformity.

So IMO it looks better if we trust the defines to do the conversion itself.

Please let me know if you think the other way.

Thanks,
Mani

> Outside of this issue, the remainder of the patch looks
> OK to me.
> 
> 					-Alex
> 
> >   /* Channel reset command */
> >   #define MHI_TRE_CMD_RESET_PTR (0)
> >   #define MHI_TRE_CMD_RESET_DWORD0 (0)
> > -#define MHI_TRE_CMD_RESET_DWORD1(chid) ((chid << 24) | \
> > -					(MHI_CMD_RESET_CHAN << 16))
> > +#define MHI_TRE_CMD_RESET_DWORD1(chid) (cpu_to_le32((chid << 24) | \
> > +					(MHI_CMD_RESET_CHAN << 16)))
> >   /* Channel stop command */
> >   #define MHI_TRE_CMD_STOP_PTR (0)
> >   #define MHI_TRE_CMD_STOP_DWORD0 (0)
> > -#define MHI_TRE_CMD_STOP_DWORD1(chid) ((chid << 24) | \
> > -				       (MHI_CMD_STOP_CHAN << 16))
> > +#define MHI_TRE_CMD_STOP_DWORD1(chid) (cpu_to_le32((chid << 24) | \
> > +				       (MHI_CMD_STOP_CHAN << 16)))
> >   /* Channel start command */
> >   #define MHI_TRE_CMD_START_PTR (0)
> >   #define MHI_TRE_CMD_START_DWORD0 (0)
> > -#define MHI_TRE_CMD_START_DWORD1(chid) ((chid << 24) | \
> > -					(MHI_CMD_START_CHAN << 16))
> > +#define MHI_TRE_CMD_START_DWORD1(chid) (cpu_to_le32((chid << 24) | \
> > +					(MHI_CMD_START_CHAN << 16)))
> > -#define MHI_TRE_GET_CMD_CHID(tre) (((tre)->dword[1] >> 24) & 0xFF)
> > -#define MHI_TRE_GET_CMD_TYPE(tre) (((tre)->dword[1] >> 16) & 0xFF)
> > +#define MHI_TRE_GET_DWORD(tre, word) (le32_to_cpu((tre)->dword[(word)]))
> > +#define MHI_TRE_GET_CMD_CHID(tre) ((MHI_TRE_GET_DWORD(tre, 1) >> 24) & 0xFF)
> > +#define MHI_TRE_GET_CMD_TYPE(tre) ((MHI_TRE_GET_DWORD(tre, 1) >> 16) & 0xFF)
> >   /* Event descriptor macros */
> > -#define MHI_TRE_EV_PTR(ptr) (ptr)
> > -#define MHI_TRE_EV_DWORD0(code, len) ((code << 24) | len)
> > -#define MHI_TRE_EV_DWORD1(chid, type) ((chid << 24) | (type << 16))
> > -#define MHI_TRE_GET_EV_PTR(tre) ((tre)->ptr)
> > -#define MHI_TRE_GET_EV_CODE(tre) (((tre)->dword[0] >> 24) & 0xFF)
> > -#define MHI_TRE_GET_EV_LEN(tre) ((tre)->dword[0] & 0xFFFF)
> > -#define MHI_TRE_GET_EV_CHID(tre) (((tre)->dword[1] >> 24) & 0xFF)
> > -#define MHI_TRE_GET_EV_TYPE(tre) (((tre)->dword[1] >> 16) & 0xFF)
> > -#define MHI_TRE_GET_EV_STATE(tre) (((tre)->dword[0] >> 24) & 0xFF)
> > -#define MHI_TRE_GET_EV_EXECENV(tre) (((tre)->dword[0] >> 24) & 0xFF)
> > -#define MHI_TRE_GET_EV_SEQ(tre) ((tre)->dword[0])
> > -#define MHI_TRE_GET_EV_TIME(tre) ((tre)->ptr)
> > -#define MHI_TRE_GET_EV_COOKIE(tre) lower_32_bits((tre)->ptr)
> > -#define MHI_TRE_GET_EV_VEID(tre) (((tre)->dword[0] >> 16) & 0xFF)
> > -#define MHI_TRE_GET_EV_LINKSPEED(tre) (((tre)->dword[1] >> 24) & 0xFF)
> > -#define MHI_TRE_GET_EV_LINKWIDTH(tre) ((tre)->dword[0] & 0xFF)
> > +#define MHI_TRE_EV_PTR(ptr) (cpu_to_le64(ptr))
> > +#define MHI_TRE_EV_DWORD0(code, len) (cpu_to_le32((code << 24) | len))
> > +#define MHI_TRE_EV_DWORD1(chid, type) (cpu_to_le32((chid << 24) | (type << 16)))
> > +#define MHI_TRE_GET_EV_PTR(tre) (le64_to_cpu((tre)->ptr))
> > +#define MHI_TRE_GET_EV_CODE(tre) ((MHI_TRE_GET_DWORD(tre, 0) >> 24) & 0xFF)
> > +#define MHI_TRE_GET_EV_LEN(tre) (MHI_TRE_GET_DWORD(tre, 0) & 0xFFFF)
> > +#define MHI_TRE_GET_EV_CHID(tre) ((MHI_TRE_GET_DWORD(tre, 1) >> 24) & 0xFF)
> > +#define MHI_TRE_GET_EV_TYPE(tre) ((MHI_TRE_GET_DWORD(tre, 1) >> 16) & 0xFF)
> > +#define MHI_TRE_GET_EV_STATE(tre) ((MHI_TRE_GET_DWORD(tre, 0) >> 24) & 0xFF)
> > +#define MHI_TRE_GET_EV_EXECENV(tre) ((MHI_TRE_GET_DWORD(tre, 0) >> 24) & 0xFF)
> > +#define MHI_TRE_GET_EV_SEQ(tre) MHI_TRE_GET_DWORD(tre, 0)
> > +#define MHI_TRE_GET_EV_TIME(tre) (MHI_TRE_GET_EV_PTR(tre))
> > +#define MHI_TRE_GET_EV_COOKIE(tre) lower_32_bits(MHI_TRE_GET_EV_PTR(tre))
> > +#define MHI_TRE_GET_EV_VEID(tre) ((MHI_TRE_GET_DWORD(tre, 0) >> 16) & 0xFF)
> > +#define MHI_TRE_GET_EV_LINKSPEED(tre) ((MHI_TRE_GET_DWORD(tre, 1) >> 24) & 0xFF)
> > +#define MHI_TRE_GET_EV_LINKWIDTH(tre) (MHI_TRE_GET_DWORD(tre, 0) & 0xFF)
> >   /* Transfer descriptor macros */
> > -#define MHI_TRE_DATA_PTR(ptr) (ptr)
> > -#define MHI_TRE_DATA_DWORD0(len) (len & MHI_MAX_MTU)
> > -#define MHI_TRE_DATA_DWORD1(bei, ieot, ieob, chain) ((2 << 16) | (bei << 10) \
> > -	| (ieot << 9) | (ieob << 8) | chain)
> > +#define MHI_TRE_DATA_PTR(ptr) (cpu_to_le64(ptr))
> > +#define MHI_TRE_DATA_DWORD0(len) (cpu_to_le32(len & MHI_MAX_MTU))
> > +#define MHI_TRE_DATA_DWORD1(bei, ieot, ieob, chain) (cpu_to_le32((2 << 16) | (bei << 10) \
> > +	| (ieot << 9) | (ieob << 8) | chain))
> >   /* RSC transfer descriptor macros */
> > -#define MHI_RSCTRE_DATA_PTR(ptr, len) (((u64)len << 48) | ptr)
> > -#define MHI_RSCTRE_DATA_DWORD0(cookie) (cookie)
> > -#define MHI_RSCTRE_DATA_DWORD1 (MHI_PKT_TYPE_COALESCING << 16)
> > +#define MHI_RSCTRE_DATA_PTR(ptr, len) (cpu_to_le64(((u64)len << 48) | ptr))
> > +#define MHI_RSCTRE_DATA_DWORD0(cookie) (cpu_to_le32(cookie))
> > +#define MHI_RSCTRE_DATA_DWORD1 (cpu_to_le32(MHI_PKT_TYPE_COALESCING << 16))
> >   enum mhi_pkt_type {
> >   	MHI_PKT_TYPE_INVALID = 0x0,
> > @@ -500,7 +501,7 @@ struct state_transition {
> >   struct mhi_ring {
> >   	dma_addr_t dma_handle;
> >   	dma_addr_t iommu_base;
> > -	u64 *ctxt_wp; /* point to ctxt wp */
> > +	__le64 *ctxt_wp; /* point to ctxt wp */
> >   	void *pre_aligned;
> >   	void *base;
> >   	void *rp;
> > diff --git a/drivers/bus/mhi/core/main.c b/drivers/bus/mhi/core/main.c
> > index ffde617f93a3..85f4f7c8d7c6 100644
> > --- a/drivers/bus/mhi/core/main.c
> > +++ b/drivers/bus/mhi/core/main.c
> > @@ -114,7 +114,7 @@ void mhi_ring_er_db(struct mhi_event *mhi_event)
> >   	struct mhi_ring *ring = &mhi_event->ring;
> >   	mhi_event->db_cfg.process_db(mhi_event->mhi_cntrl, &mhi_event->db_cfg,
> > -				     ring->db_addr, *ring->ctxt_wp);
> > +				     ring->db_addr, le64_to_cpu(*ring->ctxt_wp));
> >   }
> >   void mhi_ring_cmd_db(struct mhi_controller *mhi_cntrl, struct mhi_cmd *mhi_cmd)
> > @@ -123,7 +123,7 @@ void mhi_ring_cmd_db(struct mhi_controller *mhi_cntrl, struct mhi_cmd *mhi_cmd)
> >   	struct mhi_ring *ring = &mhi_cmd->ring;
> >   	db = ring->iommu_base + (ring->wp - ring->base);
> > -	*ring->ctxt_wp = db;
> > +	*ring->ctxt_wp = cpu_to_le64(db);
> >   	mhi_write_db(mhi_cntrl, ring->db_addr, db);
> >   }
> > @@ -140,7 +140,7 @@ void mhi_ring_chan_db(struct mhi_controller *mhi_cntrl,
> >   	 * before letting h/w know there is new element to fetch.
> >   	 */
> >   	dma_wmb();
> > -	*ring->ctxt_wp = db;
> > +	*ring->ctxt_wp = cpu_to_le64(db);
> >   	mhi_chan->db_cfg.process_db(mhi_cntrl, &mhi_chan->db_cfg,
> >   				    ring->db_addr, db);
> > @@ -432,7 +432,7 @@ irqreturn_t mhi_irq_handler(int irq_number, void *dev)
> >   	struct mhi_event_ctxt *er_ctxt =
> >   		&mhi_cntrl->mhi_ctxt->er_ctxt[mhi_event->er_index];
> >   	struct mhi_ring *ev_ring = &mhi_event->ring;
> > -	dma_addr_t ptr = er_ctxt->rp;
> > +	dma_addr_t ptr = le64_to_cpu(er_ctxt->rp);
> >   	void *dev_rp;
> >   	if (!is_valid_ring_ptr(ev_ring, ptr)) {
> > @@ -537,14 +537,14 @@ static void mhi_recycle_ev_ring_element(struct mhi_controller *mhi_cntrl,
> >   	/* Update the WP */
> >   	ring->wp += ring->el_size;
> > -	ctxt_wp = *ring->ctxt_wp + ring->el_size;
> > +	ctxt_wp = le64_to_cpu(*ring->ctxt_wp) + ring->el_size;
> >   	if (ring->wp >= (ring->base + ring->len)) {
> >   		ring->wp = ring->base;
> >   		ctxt_wp = ring->iommu_base;
> >   	}
> > -	*ring->ctxt_wp = ctxt_wp;
> > +	*ring->ctxt_wp = cpu_to_le64(ctxt_wp);
> >   	/* Update the RP */
> >   	ring->rp += ring->el_size;
> > @@ -801,7 +801,7 @@ int mhi_process_ctrl_ev_ring(struct mhi_controller *mhi_cntrl,
> >   	struct device *dev = &mhi_cntrl->mhi_dev->dev;
> >   	u32 chan;
> >   	int count = 0;
> > -	dma_addr_t ptr = er_ctxt->rp;
> > +	dma_addr_t ptr = le64_to_cpu(er_ctxt->rp);
> >   	/*
> >   	 * This is a quick check to avoid unnecessary event processing
> > @@ -940,7 +940,7 @@ int mhi_process_ctrl_ev_ring(struct mhi_controller *mhi_cntrl,
> >   		mhi_recycle_ev_ring_element(mhi_cntrl, ev_ring);
> >   		local_rp = ev_ring->rp;
> > -		ptr = er_ctxt->rp;
> > +		ptr = le64_to_cpu(er_ctxt->rp);
> >   		if (!is_valid_ring_ptr(ev_ring, ptr)) {
> >   			dev_err(&mhi_cntrl->mhi_dev->dev,
> >   				"Event ring rp points outside of the event ring\n");
> > @@ -970,7 +970,7 @@ int mhi_process_data_event_ring(struct mhi_controller *mhi_cntrl,
> >   	int count = 0;
> >   	u32 chan;
> >   	struct mhi_chan *mhi_chan;
> > -	dma_addr_t ptr = er_ctxt->rp;
> > +	dma_addr_t ptr = le64_to_cpu(er_ctxt->rp);
> >   	if (unlikely(MHI_EVENT_ACCESS_INVALID(mhi_cntrl->pm_state)))
> >   		return -EIO;
> > @@ -1011,7 +1011,7 @@ int mhi_process_data_event_ring(struct mhi_controller *mhi_cntrl,
> >   		mhi_recycle_ev_ring_element(mhi_cntrl, ev_ring);
> >   		local_rp = ev_ring->rp;
> > -		ptr = er_ctxt->rp;
> > +		ptr = le64_to_cpu(er_ctxt->rp);
> >   		if (!is_valid_ring_ptr(ev_ring, ptr)) {
> >   			dev_err(&mhi_cntrl->mhi_dev->dev,
> >   				"Event ring rp points outside of the event ring\n");
> > @@ -1533,7 +1533,7 @@ static void mhi_mark_stale_events(struct mhi_controller *mhi_cntrl,
> >   	/* mark all stale events related to channel as STALE event */
> >   	spin_lock_irqsave(&mhi_event->lock, flags);
> > -	ptr = er_ctxt->rp;
> > +	ptr = le64_to_cpu(er_ctxt->rp);
> >   	if (!is_valid_ring_ptr(ev_ring, ptr)) {
> >   		dev_err(&mhi_cntrl->mhi_dev->dev,
> >   			"Event ring rp points outside of the event ring\n");
> > diff --git a/drivers/bus/mhi/core/pm.c b/drivers/bus/mhi/core/pm.c
> > index 4aae0baea008..c35c5ddc7220 100644
> > --- a/drivers/bus/mhi/core/pm.c
> > +++ b/drivers/bus/mhi/core/pm.c
> > @@ -218,7 +218,7 @@ int mhi_ready_state_transition(struct mhi_controller *mhi_cntrl)
> >   			continue;
> >   		ring->wp = ring->base + ring->len - ring->el_size;
> > -		*ring->ctxt_wp = ring->iommu_base + ring->len - ring->el_size;
> > +		*ring->ctxt_wp = cpu_to_le64(ring->iommu_base + ring->len - ring->el_size);
> >   		/* Update all cores */
> >   		smp_wmb();
> > @@ -420,7 +420,7 @@ static int mhi_pm_mission_mode_transition(struct mhi_controller *mhi_cntrl)
> >   			continue;
> >   		ring->wp = ring->base + ring->len - ring->el_size;
> > -		*ring->ctxt_wp = ring->iommu_base + ring->len - ring->el_size;
> > +		*ring->ctxt_wp = cpu_to_le64(ring->iommu_base + ring->len - ring->el_size);
> >   		/* Update to all cores */
> >   		smp_wmb();
> 
