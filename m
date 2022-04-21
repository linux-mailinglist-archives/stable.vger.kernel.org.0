Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DEC95509CF9
	for <lists+stable@lfdr.de>; Thu, 21 Apr 2022 12:01:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383630AbiDUKAu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Apr 2022 06:00:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232617AbiDUKAs (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 Apr 2022 06:00:48 -0400
Received: from out1-smtp.messagingengine.com (out1-smtp.messagingengine.com [66.111.4.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E44521250
        for <stable@vger.kernel.org>; Thu, 21 Apr 2022 02:57:59 -0700 (PDT)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id D1AEC5C0066;
        Thu, 21 Apr 2022 05:57:56 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Thu, 21 Apr 2022 05:57:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm1; t=1650535076; x=1650621476; bh=Xx/L/A1bmI
        /QL5A3zOoSC7TidXFkGQLJGbzpMgyNeU8=; b=iamVrY2D/FYjAVOILwSOIPRPjL
        rAIN34H2NeYtIKAj2CSvnYMKUI18IQtAXzATR5nsdV6zABIpEn01+ltPUxvaXWFu
        Mzw6ONRiVQ6FDxZ7HgG4pUZag6Ial+REBRqd2OzKf35oTnkX5qq4K2KVmDOaJUsg
        bN20Xymv4A7N1UNs6Y8R4wS1hiNM54F+u3haRe86NnD1+pgVktp1snrzxoALj695
        hn5MGo7VNuvJIlnsgruRFI4oDxmXv6SFfW289moeY/nv00FAJLUO4LPDyQCLLLR4
        blHCUmqFmV3EUlrjxFvEhLSVJFjGdpwGA9InTr1QCB0VHe2jJl+3OZwoHS4w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1650535076; x=
        1650621476; bh=Xx/L/A1bmI/QL5A3zOoSC7TidXFkGQLJGbzpMgyNeU8=; b=S
        ChZD87/zljILSaZGbJkw09k8lJJPi0pAL1zYTGZSbzUP6AcJYlV6PFfLE6DvPGSt
        VPQ5ApeRHKeaFwGRuiQ6JcGZ+sGGvgE3kWXVU8Z85x5uy1cRDyUnWTjO27O2Xp1a
        ioKUc3yPVEnrxZMEQF+QnGQTfyH1igIahwpqDP2lx4vaTYgpfQ17NesnO9eOh44v
        8hVD0i7QpWfrDv4m97GIQOZjHLkBBokALXC1SCKrJpHkczdbsVLiGRkOw9Q8SHF5
        hPDIRQ7E1Pb6EK+X4+tUG2wY0DJEvwBviVFneHJkvCOGayxPXdjwDq3QjA3NB1Xz
        JHUY/rNwF0Rs4a0rd23uA==
X-ME-Sender: <xms:pCphYsyoSj5MwJXwSMMYO2BWdSUQwTZbVofVq8iI8RMybRjUy389eg>
    <xme:pCphYgRDd2UOsZ-GayTvJz5tHvYF9tBFS0jwMOvuFNQprwaNlLvT5pGWGBVgWpYJX
    ngGTTqmxLgsHQ>
X-ME-Received: <xmr:pCphYuV4DZFSKLTBFx6l3nLUvHG99TAuonB4EA4CsnFw-eNqRfR3FdhyR_oL9odkEN4lS9RU4uOd8uwzRZ9a1VueznxxdLs2>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrtddvgddvudcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvvefukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeehgedvve
    dvleejuefgtdduudfhkeeltdeihfevjeekjeeuhfdtueefhffgheekteenucevlhhushht
    vghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:pCphYqijWSsXMC1T7b1JFXTRzTFTy9Cx8c1sIAYmNmzxch6faGu_kA>
    <xmx:pCphYuBiV8mz-ZXxYPwrYoaYHNWoK7yxYDrFUlZICql8KYxremWfPw>
    <xmx:pCphYrL1cCTwdS7EcOh1DDx8LE2VQs_jXSYBrrZv9tdATyoAYAnWKg>
    <xmx:pCphYhPs12GoKDkmu08b-wf2rAS5fvD4JXHHZupgyhgCiMK5FHE8FQ>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 21 Apr 2022 05:57:56 -0400 (EDT)
Date:   Thu, 21 Apr 2022 11:57:53 +0200
From:   Greg KH <greg@kroah.com>
To:     Adrian Hunter <adrian.hunter@intel.com>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 5.10 5.15 5.17] perf tools: Fix segfault accessing
 sample_id xyarray
Message-ID: <YmEqoQAdQVusYHN/@kroah.com>
References: <20220419111029.118039-1-adrian.hunter@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220419111029.118039-1-adrian.hunter@intel.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 19, 2022 at 02:10:29PM +0300, Adrian Hunter wrote:
> commit a668cc07f990d2ed19424d5c1a529521a9d1cee1 upstream
> 
> perf_evsel::sample_id is an xyarray which can cause a segfault when
> accessed beyond its size. e.g.
> 
>   # perf record -e intel_pt// -C 1 sleep 1
>   Segmentation fault (core dumped)
>   #

Now queued up, thanks.

greg k-h
