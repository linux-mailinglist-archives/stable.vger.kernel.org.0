Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 74EFCEDD36
	for <lists+stable@lfdr.de>; Mon,  4 Nov 2019 12:00:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727607AbfKDLAJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Nov 2019 06:00:09 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:46577 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726071AbfKDLAJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Nov 2019 06:00:09 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 18A8321EAD;
        Mon,  4 Nov 2019 06:00:08 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Mon, 04 Nov 2019 06:00:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=47JFszclw3ivPKlFWCLJo245qfM
        1Wu/Tc5GwYN7u9D4=; b=H156Z4AYOg08MXCtwbdnAQK4q7YurH5I5jiXU6M7M4F
        pglsTXQpSazApmQIkXVAfZErxNi0koG73ICzoD7YNIFmlvqz53Y4FxNcgeFqP4FJ
        RTouA8iu3xH4/gjPPf7LKSRzs73lcG6x+/4A7Ao2GLYRD/BkHSgnBV2b+eBNY0CX
        HxTCg0OTeSjNUA3UA6JkTIWnXTrksXJmvFCCD+J18FwedL0IhGS8fZi0zeredXlT
        s0wfVKaqePcrYMszv0+8hE9NjCY0mmX3Ciz+qPR18+lvPqvukmWLwSIHytgpT6H3
        sUPHs+VWa4sKrbumod6RM45BJINZ1LkS3FCz0CGPDpw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=47JFsz
        clw3ivPKlFWCLJo245qfM1Wu/Tc5GwYN7u9D4=; b=e0kbV+JI/sO0tljTMHP1br
        5hW4K91vyhl9M4aKwyObKWKosx229F+QHd3WphdN3SETvDcIMP6L0H570Mt1xW8p
        6ua/nmxR4dIA/uGEdVCF8Ec4qV9Q10hpfI+diCreBwRqjqlcBXDxBkCHkrO7geZL
        IdDrxZCtEBTPjP7W4HKjb75e2kafNrS48Hki0UZqE189ZJ2nb0ACwFz3tItZRuzG
        ofKbpqsSiJWrpZToOI0ZDt0cnuJKfYpNno8Vv/FwkYBmBTJZ+SbuiieO9xsrQQYK
        296MjS9Uum8an8bT7zA4lRJ+uT1IdYIeMOjxtmVPq+1PWyV9XGOJMMMOlcuiVrtw
        ==
X-ME-Sender: <xms:twTAXTBoe8QIptRAE2BhQ7suOgqWa-hqaAUt94LJX3_ALaRRY_mTvA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedruddufedgvddvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpeffhffvuffkfhggtggujggfsehttd
    ertddtredvnecuhfhrohhmpefirhgvghcumffjuceoghhrvghgsehkrhhorghhrdgtohhm
    qeenucfkphepkeefrdekiedrkeelrddutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    hgrhgvgheskhhrohgrhhdrtghomhenucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:twTAXdoeXO5YAyggB1Dcs96CpHQDryKFtInXiPrYFP8pFp9gxN0J_w>
    <xmx:twTAXbm9LQcwN-G3WRSR_ullRodu8pxHTuxN9kHDwvDXHMM7jmOFUw>
    <xmx:twTAXQWaWz5auL_db_7Vd4C0pBYfxeWB4jvv_vcCvjM4zFnq3LQvYQ>
    <xmx:uATAXUE6B3ZcJSokqf8EeYhqANJOImG4zRzf-uC8DVXy3zJXY1wbnw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 4D280306006D;
        Mon,  4 Nov 2019 06:00:07 -0500 (EST)
Date:   Mon, 4 Nov 2019 12:00:02 +0100
From:   Greg KH <greg@kroah.com>
To:     Thomas Deutschmann <whissi@gentoo.org>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        luciano.coelho@intel.com
Subject: Re: Please backport 12e36d98d3e for 5.1+: iwlwifi: exclude GEO SAR
 support for 3168
Message-ID: <20191104110002.GC1945210@kroah.com>
References: <7a5f833a-3183-6a64-cd35-80d131343089@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7a5f833a-3183-6a64-cd35-80d131343089@gentoo.org>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Nov 02, 2019 at 03:36:03PM +0100, Thomas Deutschmann wrote:
> Hi,
> 
> please backport
> 
> <<<<snip
> >From 12e36d98d3e5acf5fc57774e0a15906d55f30cb9 Mon Sep 17 00:00:00 2001
> From: Luca Coelho <luciano.coelho@intel.com>
> Date: Tue, 8 Oct 2019 13:10:53 +0300
> Subject: iwlwifi: exclude GEO SAR support for 3168
> 
> We currently support two NICs in FW version 29, namely 7265D and 3168.
> Out of these, only 7265D supports GEO SAR, so adjust the function that
> checks for it accordingly.
> 
> Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
> Fixes: f5a47fae6aa3 ("iwlwifi: mvm: fix version check for
> GEO_TX_POWER_LIMIT support")
> Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
> snap>>>
> 
> This was the first patch of a 2 patch patch series. The second patch,
> aa0cc7dde17 ("iwlwifi: pcie: change qu with jf devices to use qu
> configuration") had "Cc: stable@vger.kernel.org # 5.1+" and was added.
> The first one was missed.

Now queued up,t hanks.

greg k-h
