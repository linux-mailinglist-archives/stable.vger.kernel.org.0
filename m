Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 216E2537247
	for <lists+stable@lfdr.de>; Sun, 29 May 2022 21:04:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231732AbiE2TED (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 May 2022 15:04:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229811AbiE2TEC (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 29 May 2022 15:04:02 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4045D579BF
        for <stable@vger.kernel.org>; Sun, 29 May 2022 12:04:01 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id 129-20020a1c0287000000b003974edd7c56so3913088wmc.2
        for <stable@vger.kernel.org>; Sun, 29 May 2022 12:04:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=MtzNwdll4LTazb3SnDmOfdBWik1I1Q3tYPCC6MNC+oU=;
        b=Db9IdsVz4okVy/S44zxw3DOHLc6tberVKjnPVcR8LIaTHhBJ9kG87hx06QXf3NGil+
         0UVgxCAlf2Ex6VL6uI8y8UyHbVVRBVZ4/NQiZgwzlX9/lFNPL+tkAWfXoSNqLgOnyGNU
         DsoRqvGoj3kUqkY6rDexOmTpCJGM1ewGACFXQ+jfYk8RIqEK0+LWfY59qNM4W4ygaAVe
         vMDW8Re6FVMDhtI9VY97uOD4Etml70cm8B5JNeZG/EdIYsUKNmQ3M6thi4bue3bAXyIX
         U0AGTO2yfN8Lzmo96DRaH2IGdpcxyMY9eq5oQY+m1K0Ehl5/K2H3HHsoRaS5Y1C+XsLi
         hc5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=MtzNwdll4LTazb3SnDmOfdBWik1I1Q3tYPCC6MNC+oU=;
        b=cVkfurzXLUvIOOBgMIx2mhAO6OFfACcDuHa4t2XxU9s0mnrmWvF5uP3o8JKeEA8LkZ
         xfjASyzHNC2d2Oi7CIlq3UpCUXkFu9ykBfVDtlu2T6d/61+6vFsrS2B20nrmjd/sFvD3
         b+m86wq3N6IjpoO9QXKYXY35wCpATAxh5JMX7RYfrFUKJbSsy6ByDXnz9faasHAJSY7z
         6Ytqxl6NEXvGWQhvqMC43EE6IpBE/DUosnqe2dZHtmhKlXVxzb5YMmFz3b2LSgN8laRZ
         ssAOU2PmrFo6KvZoAz7zgV4JSHoQzXKXf+/IFTIuquHTuNUw5swh9nfKKDRASR4tZaZ5
         z9fQ==
X-Gm-Message-State: AOAM533fWx4chb7EVqyt6bGf1axFdw3Wh9jQRzsf6P1YjRb+VGTc/sOe
        iSvGVcbA9KNDHdr4M0mCsJa0dw==
X-Google-Smtp-Source: ABdhPJxx0AIi2dkIWVCXl7rwvfW5NdZbl6YNOoydU2sAUy31f4xaRC6B/EepgHM7fQOYwYnG14sz3g==
X-Received: by 2002:a05:600c:3c8f:b0:39b:808c:b5cb with SMTP id bg15-20020a05600c3c8f00b0039b808cb5cbmr3597003wmb.11.1653851039490;
        Sun, 29 May 2022 12:03:59 -0700 (PDT)
Received: from 6wind.com ([2a01:e0a:5ac:6460:c065:401d:87eb:9b25])
        by smtp.gmail.com with ESMTPSA id m5-20020a5d64a5000000b0020c5253d8casm7937420wrp.22.2022.05.29.12.03.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 May 2022 12:03:58 -0700 (PDT)
Date:   Sun, 29 May 2022 21:03:57 +0200
From:   Olivier Matz <olivier.matz@6wind.com>
To:     Piotr Skajewski <piotrx.skajewski@intel.com>
Cc:     intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        davem@davemloft.net, pabeni@redhat.com, pmenzel@molgen.mpg.de,
        stable@vger.kernel.org, nicolas.dichtel@6wind.com,
        alexandr.lobakin@intel.com, maciej.fijalkowski@intel.com,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com
Subject: Re: [Intel-wired-lan] [PATCH net v2 0/2] ixgbe: fix promiscuous mode
 on VF
Message-ID: <YpPDnXRlxC5doIAJ@platinum>
References: <20220406095252.22338-1-olivier.matz@6wind.com>
 <20220526141015.43057-1-piotrx.skajewski@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220526141015.43057-1-piotrx.skajewski@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Piotr,

On Thu, May 26, 2022 at 04:10:15PM +0200, Piotr Skajewski wrote:
> > On Mon, Apr 25, 2022 at 01:51:53PM +0200, Olivier Matz wrote:
> > > Hi,
> > > 
> > > On Wed, Apr 06, 2022 at 11:52:50AM +0200, Olivier Matz wrote:
> > > > These 2 patches fix issues related to the promiscuous mode on VF.
> > > > 
> > > > Comments are welcome,
> > > > Olivier
> > > > 
> > > > Cc: stable@vger.kernel.org
> > > > Cc: Nicolas Dichtel <nicolas.dichtel@6wind.com>
> > > > 
> > > > Changes since v1:
> > > > - resend with CC intel-wired-lan
> > > > - remove CC Hiroshi Shimamoto (address does not exist anymore)
> > > > 
> > > > Olivier Matz (2):
> > > >   ixgbe: fix bcast packets Rx on VF after promisc removal
> > > >   ixgbe: fix unexpected VLAN Rx in promisc mode on VF
> > > > 
> > > >  drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c | 8 ++++----
> > > >  1 file changed, 4 insertions(+), 4 deletions(-)
> > > 
> > > Any feedback about this patchset?
> > > Comments are welcome.
> >
> > I didn't get feedback for this patchset until now. Am I doing things
> > correctly? Am I targeting the appropriate mailing lists and people?
> >
> > Please let me know if I missed something.
> 
> Hi Olivier,
> 
> Sorry for the late reply,
> We had to analyze it internally and it took us some time.
> After reviewing, we decided that the proposed patches could be accepted.
> 
> ACK for series.

No problem for the delay.
Thank you!

Olivier
