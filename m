Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6E92548301
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 11:15:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232579AbiFMJEA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 05:04:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232513AbiFMJD6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 05:03:58 -0400
Received: from wout2-smtp.messagingengine.com (wout2-smtp.messagingengine.com [64.147.123.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E720BE0A6
        for <stable@vger.kernel.org>; Mon, 13 Jun 2022 02:03:56 -0700 (PDT)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.west.internal (Postfix) with ESMTP id 51A743200926;
        Mon, 13 Jun 2022 05:03:54 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Mon, 13 Jun 2022 05:03:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm2; t=1655111033; x=1655197433; bh=38IYgtNUdc
        uy5s0C1KyhMS+ihq9wIFPDvXNjQ9lLHX0=; b=qrun0I2rL8tstw+RdGfr+yQBfl
        cSJXco+fXPmGGopiBaHk88ER4SJSSAQV6wQfSKPq7+p4CCcptXlRksuRzGarvYQv
        TrwKy631z8LoC/X8cDTZVone0i29vdylwpFqJpJpB+EiA0B0jZeRzw0QTO8Pq3KG
        0lhVPGmQiP4GroLN9aMGHVYj3yhhF3aHG1NJ3TQ0fPShfSBDt381NiiDcOHntSRq
        gVC62TIk5ucyUJJ29CDCLrx9xpM4oteg/9Vme96y7lA2j5UvQlookyVUnD1VSlfD
        pz7D1LzcC5ROLUcB63RZwUQ6aqDMSCYjgAWf1EuDcgpEFQpiiMGk6MYFo2EA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; t=1655111033; x=1655197433; bh=38IYgtNUdcuy5s0C1KyhMS+ihq9w
        IFPDvXNjQ9lLHX0=; b=ipzUlM8kmqeR7JlTQBr3jmXpAkz72fVnAxTnyTF+ZCOv
        LVG8nBw9/F5DOtKXULAw8eGNrl0SmDaCNsU3lOC5LDzTmIHLer8wxs3LxWkvUlUO
        tGGqy+i31xhYdz4AEPQ50ZO6k1umnjZgqPDtjXx2zNiWehZ+PUyEA9HDTmSm5tJK
        zUscLJEVFfzQtZZgsRlBUgpu7VYCoVYuKCqxUpDRGBB3YvgzrRr36mWETU0kfOmn
        hfdujg/u7EXiyBHJTmZMs7GORI667i/wMOQDav+HBYm2TlUrPCmxGC5Gmohg5QCG
        L+uhulN1eqDmMntWo6Q/W1QDua1JahUzHzmKjR7Cfg==
X-ME-Sender: <xms:ef2mYjQG9v77ZBHyOdjRN_S2jXSylK0MuVIVXZ2PaoLtHY5Wmnc52A>
    <xme:ef2mYkx4ObAi2Tk3UQib-uS-v7s06kjuC7bjpJwkdb-ZplbxD2FzAnbRYXOMwbsGM
    APd3HFLfGREPg>
X-ME-Received: <xmr:ef2mYo3Y_G8R9Y1uGWizSDTRKNja2CDofkWHfAE4gz2NehpTJN6eQ13US7EOYqB_p71ab0PNVKQl9pSnf5__sVX9YQcwJY2z>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedruddujedguddtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepjeduge
    fggffffffhhfdvhffghedvteegteeuhfeifefhueevvdeffedugeehgfeknecuffhomhgr
    ihhnpeguvggsihgrnhdrohhrghenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmh
    epmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:ef2mYjBOFgZVzGb3807jbtuHTsqKDCDdamYGySGal1-Rpkxq892fWg>
    <xmx:ef2mYsguQpKR8jJCkP0ZrlI4mnJHM_zI8NqnKZNlJdZwYxCbGPMs1g>
    <xmx:ef2mYno3fM29wV0mzs1BjzahnaP6zWAJFouOoYiFCiA7OSuCNTK3fQ>
    <xmx:ef2mYvtMSa0yPQVLhdzwgpKO6S9olMDgXWl-Sr5Pv8PY4eesuBRMow>
Feedback-ID: i787e41f1:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 13 Jun 2022 05:03:53 -0400 (EDT)
Date:   Mon, 13 Jun 2022 11:03:51 +0200
From:   Greg KH <greg@kroah.com>
To:     Pascal Hambourg <pascal@plouf.fr.eu.org>
Cc:     stable@vger.kernel.org
Subject: Re: md/raid0: Ignore RAID0 layout if the second zone has only one
 device
Message-ID: <Yqb9d8O/DGCiuiYA@kroah.com>
References: <9257c1c4-d052-9e05-9016-8321c2cc47c6@plouf.fr.eu.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9257c1c4-d052-9e05-9016-8321c2cc47c6@plouf.fr.eu.org>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Jun 11, 2022 at 11:14:38AM +0200, Pascal Hambourg wrote:
> Please apply
> Upstream commit ea23994edc4169bd90d7a9b5908c6ccefd82fa40
> to kernel versions 4.14, 4.19, 5.4 and above.
> 
> Reason:
> Commits c84a1372df929033cb1a0441fb57bd3932f39ac9 "md/raid0: avoid RAID0 data
> corruption due to layout confusion." and
> 33f2c35a54dfd75ad0e7e86918dcbe4de799a56c "md: add feature flag
> MD_FEATURE_RAID0_LAYOUT" added handling of original and alternate layouts of
> RAID0 arrays with members of different sizes. However they introduced a
> regression: assembly of such RAID0 array fails if the per-array or default
> layout is not defined even when the layout is irrelevant and can be safely
> ignored. One common case is when the RAID0 array is composed of two members
> of different sizes because the disk or partition sizes are slightly
> different. This patch aims to fix this regression.
> 
> Newer versions of mdadm can set a per-array RAID0 layout but some stable
> distributions such as Debian 10 ship an older version of mdadm which does
> not handle RAID0 layouts and a kernel series (4.19.y) which now includes the
> backported commits. As a result, assembly fails after the kernel upgrade
> unless the default layout is defined with a kernel parameter.
> 
> Related Debian bug reports :
> https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=944676
> https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=954816

Now queued up, thanks.

greg k-h
