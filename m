Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F3D6C79292
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 19:49:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727585AbfG2RtG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 13:49:06 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:49517 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726627AbfG2RtG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Jul 2019 13:49:06 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 678A92227B;
        Mon, 29 Jul 2019 13:49:05 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Mon, 29 Jul 2019 13:49:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=VqodAuV95QLJre6Fma7GchXCohz
        094a6+WwaebtLix4=; b=OmAsDB9lOAs63PcYn3p5EAkrtXe+us0XTvuSsuRHf3k
        3SQysNXy/N9Jr5MbA8Up0xjuDtjORBSams7rx1j3JoYtBWhCxz6TpJVEMJ1pm07V
        eeeZpz28NhQFkHzLByieDTDin8hG7UJSiw5ZF+Iqzt4DSYpXDbjvtW0UQ2oq0QGC
        ZYQsh8uuvroK0lCXICpRogiWSgO/dWq93Mel6+jIP5Gb30ATXVloPokhUKY9zzsC
        QLlFtZdQc7QIBYBeASPvZQuSajFzBivSCzext9PDiOzN3Y38E0ntuRJGjtgDTDx4
        3yLxpZmYlbFpjenKfHSUb3p9RYs+n6UWvdF7Je6JIsA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=VqodAu
        V95QLJre6Fma7GchXCohz094a6+WwaebtLix4=; b=MTZalJR5VUWNQAK8L3sa2/
        0Y8KlCxqCQSSREGOh3VSCxo0Z8n3R5If6o7ZPAkaaZMKIj9PkjARAetUQrGYrMXw
        DZY/qYspqH1BCAFohw7uRORR800OmQYNTEcNGbcBz2s5obq5qzz8RCOR2yJViOXX
        AorImD/Owl+qa46kt2vBDDh2eH5OOtvc891UnQ8fSx/dxeql2vcmiYn6OxwueJbz
        Q+m2awK+FpD99jmX6MBkLS6/LcRqSgFLqTM8WMEuICRpjwZ0eE6SU3KBunh1k6Zw
        QEPEcWPCoVWNPevfxoZXKuypNxYq43bF0XU7yD4z28+AarL9UIYNCyrQmytp0SvA
        ==
X-ME-Sender: <xms:kTE_XQC74quesGDFsB_Nj2G0xkTomR1zfVh_zWdZFUBKT3rbmJK4hA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrledugdduudejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjfgesthdtredttdervdenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuffhomhgrihhnpehfrhgvvgguvg
    hskhhtohhprdhorhhgnecukfhppeekfedrkeeirdekledruddtjeenucfrrghrrghmpehm
    rghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivg
    eptd
X-ME-Proxy: <xmx:kTE_XUA7bQr6U7WwReBRVvNaf_waocReHBs0ddczk2KuUTv9krOmTA>
    <xmx:kTE_XROTY9XgoR_s_3Mpxua6Y516JNX_yCuvjSe0bIgXz-sDTsx5ig>
    <xmx:kTE_XeNjzG3JLhVAu4E13sQOdYDwOruHtiYec-bwK6XXm6IUUPCYnA>
    <xmx:kTE_XXupMy5aCUugoRRTesRFgxWymWF8UFUlRQdS50e1UkqFqp-Ovg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 5B01D380079;
        Mon, 29 Jul 2019 13:49:04 -0400 (EDT)
Date:   Mon, 29 Jul 2019 19:49:02 +0200
From:   Greg KH <greg@kroah.com>
To:     Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 2/8] drm/i915/perf: fix ICL perf register offsets
Message-ID: <20190729174902.GB19326@kroah.com>
References: <20190726073556.9011-1-joonas.lahtinen@linux.intel.com>
 <20190726073556.9011-3-joonas.lahtinen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190726073556.9011-3-joonas.lahtinen@linux.intel.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jul 26, 2019 at 10:35:50AM +0300, Joonas Lahtinen wrote:
> From: Lionel Landwerlin <lionel.g.landwerlin@intel.com>
> 
> We got the wrong offsets (could they have changed?). New values were
> computed off an error state by looking up the register offset in the
> context image as written by the HW.
> 
> Signed-off-by: Lionel Landwerlin <lionel.g.landwerlin@intel.com>
> Fixes: 1de401c08fa805 ("drm/i915/perf: enable perf support on ICL")
> Acked-by: Kenneth Graunke <kenneth@whitecape.org>
> Link: https://patchwork.freedesktop.org/patch/msgid/20190610081914.25428-1-lionel.g.landwerlin@intel.com
> (cherry picked from commit 8dcfdfb4501012a8d36d2157dc73925715f2befb)

This commit id is not in Linus's tree :(

