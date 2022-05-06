Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E62351D44B
	for <lists+stable@lfdr.de>; Fri,  6 May 2022 11:24:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344584AbiEFJ2F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 May 2022 05:28:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343615AbiEFJ2E (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 6 May 2022 05:28:04 -0400
Received: from wout1-smtp.messagingengine.com (wout1-smtp.messagingengine.com [64.147.123.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A151C64718;
        Fri,  6 May 2022 02:24:21 -0700 (PDT)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.west.internal (Postfix) with ESMTP id 69B293200AC4;
        Fri,  6 May 2022 05:24:19 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Fri, 06 May 2022 05:24:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm1; t=1651829058; x=1651915458; bh=otT1FlxesM
        iB82wP0k5TkxLlvirVAyKN1H/idb/BNLs=; b=AMNry61Zua6gByLyYbEiS9r73X
        vJpNxNXUZQt3Y46veGlmJrwlAlB0u7QP2JYxz4nV1zDg2oI6aGTDSrwQOuKUntLc
        odTOOT+k/ILE1+DH5Szg2zCx2ifnlU/TtbCNO0cQzUpQAhVUfzngglCTRoE7TkJU
        GHlK6XFa43P+QSnc8Mco9tWo4UkJdOBMnDl0eKD4cicS7Tuil9k3fXnECvDm0B32
        3wGC2moW0pNbDTsSgVorREPRYmGOxd6b6u8/Y+O34bHMlveDx716bJ/MT371u+05
        FC6lN0PDrs5yuQYHT4yrWToe8+jfrO6plvG8PBi6BfuXfm1Riu2TH8i1Rl7g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1651829058; x=
        1651915458; bh=otT1FlxesMiB82wP0k5TkxLlvirVAyKN1H/idb/BNLs=; b=p
        Kka4+TDc/xn/WbLYzzwZiS1WkRRwAR32AVHU5Y5PngRFVQGeRNjIvkhsOMvePdB+
        QKwyu52TTNZDiDt0jEu3PLAHPNIi1nhWXBt+i6Iq+IqSCQwZITn69JpFJPAgutyt
        ljDQ0tqVFN7mhdKBMWQp8sb+0GacnfvV6aZU83QL9ZjYFaj/ZbxnAJ392ZM5QOBS
        K78j1pUHuWKUisVuz5KYIKUJsxgGr4mDVuTKDOZGUrxEI0CUwowOZlGxxnO3xK+K
        32JBWOTcbaJMe7pkpPGYq/9E4BxwEuiXUiyW+XcM21EtDQrFFQbvPkqItSJ1TWy0
        RiywlA3cJiiS1O1+Duu9Q==
X-ME-Sender: <xms:Qul0YrcTz55XsJgMnHVy4_MYYwgnfR2N3P2L4nPDUK9qNlwMSqGNgg>
    <xme:Qul0YhPri9Cp_jfcB1VlcBqH32wC5DLLdwFIbAwtsQTNTZe9Zg53TFtsPpG73BSMs
    VTkmjEoFXk4YA>
X-ME-Received: <xmr:Qul0YkiBqqcx4GHUAnoNzQ5K7KDOsTpAmgs3O2E_4RqjP4cYK4vbtZlpHv2J>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrfeefgdduhecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvvefukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeehgedvve
    dvleejuefgtdduudfhkeeltdeihfevjeekjeeuhfdtueefhffgheekteenucevlhhushht
    vghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:Qul0Ys8nA3f0c1EF8KXeCBUp67C8-2sMcQwfMHPAAqIdxBFQbH5lsA>
    <xmx:Qul0YnuxM_PwleVXhW-nbBU--vjYtawccdhcHKFixqRAs_Kb1Y1M2A>
    <xmx:Qul0YrGvwcZEM1Ac0CYEzY3p4Cz_Tf5U2kxSGQpzf-MMd2-AYfwJUg>
    <xmx:Qul0YgGlB7lVy1wbTDX0lJmpPQedYBf5HE8gwXDWffWpAQGlG0kuVg>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 6 May 2022 05:24:17 -0400 (EDT)
Date:   Fri, 6 May 2022 11:24:14 +0200
From:   Greg KH <greg@kroah.com>
To:     Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Cc:     herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
        qat-linux@intel.com, vdronov@redhat.com, stable@vger.kernel.org,
        Marco Chiappero <marco.chiappero@intel.com>
Subject: Re: [PATCH 02/12] crypto: qat - refactor submission logic
Message-ID: <YnTpPoN9JZqjqvsG@kroah.com>
References: <20220506082327.21605-1-giovanni.cabiddu@intel.com>
 <20220506082327.21605-3-giovanni.cabiddu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220506082327.21605-3-giovanni.cabiddu@intel.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, May 06, 2022 at 09:23:17AM +0100, Giovanni Cabiddu wrote:
> Move the submission loop to a new function, qat_alg_send_message(), and
> share it between the symmetric and the asymmetric algorithms.
> 
> If the HW queues are full return -ENOSPC instead of -EBUSY.
> 
> For both symmetric and asymmetric services set the number of retries
> before returning an error to a value that works for both, 20 (was 10 for
> symmetric and 100 for asymmetric).
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
> Reviewed-by: Marco Chiappero <marco.chiappero@intel.com>

What does this "fix" to require it to be backported to stable trees?

thanks,

greg k-h
