Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E34A613316
	for <lists+stable@lfdr.de>; Mon, 31 Oct 2022 10:53:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229846AbiJaJxL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Oct 2022 05:53:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229566AbiJaJxK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Oct 2022 05:53:10 -0400
Received: from out1-smtp.messagingengine.com (out1-smtp.messagingengine.com [66.111.4.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7E5EDF21;
        Mon, 31 Oct 2022 02:53:09 -0700 (PDT)
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 5AF6A5C010F;
        Mon, 31 Oct 2022 05:53:07 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 31 Oct 2022 05:53:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
        :cc:content-transfer-encoding:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to; s=fm3; t=1667209987; x=
        1667296387; bh=eshu+AS7T2V6CJGqUlmIIT5E3fB5dkg31ZzHlAzt/o0=; b=Y
        QiImhNmY95txsDnQ1ddqyu3aRTS4SD8xPN7AO6kiYBAL57RHevq5MGV6o/dqo1Gs
        qWgpXuqki9iBhBn9GYF8j5xNgf0N0+2DrpQmdoXeTzhcDPj+UN52Epqxj5zmFWfr
        wPRG/uo7biVkEVXZXQ2+BGwE7gY6PWlyCc4uVLh6oPE0cb47Wu/tdZhX/zv1RDNp
        7LRhSX2wUpSMSu8DwVNUVv2zC28xf5n/+Csnvp31D6Erbswo3SiG7APKRzXTNfmI
        9DeC//YzBa9FYd8ul9p/T+kFK4KJPxSwCFtOamBZ9YOvssoiwrO4YpO04tNGZvfc
        O53Q9QCikL8L4sX39X6gA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding
        :content-type:date:date:feedback-id:feedback-id:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1667209987; x=
        1667296387; bh=eshu+AS7T2V6CJGqUlmIIT5E3fB5dkg31ZzHlAzt/o0=; b=P
        vRkNB5Bf2a75jMlY+hQEitFtFZIPk92zmHOf0ra6j1d1CMVZqRdQfhsVIKgRiuXI
        71NiPRceozBBvEN0/Bb5DpMP0+URgRN6SAv5o2LIT6jTwKUMYl/6xhJjL/Vp0wRV
        h3m66x6O0r1GhEky8oADJe2IJ7+dP/wYB4liyZNblPJep3pR8ayvX6STL0IEx+iU
        UA5TyYIUAVDVIDv9GNNYsjvI3M3eTT1TTu/Rg59lbNemKqvjT3NCJ6IlnVHxjjaX
        r+Q4E4nU3u1PwOAu2IAkZ9w0GwLN5py4hgxUWZNxD69pG2TPEH5Ba9IV0bIxcyKv
        7F1xJH89Y/SgvArOC673Q==
X-ME-Sender: <xms:A5tfY6ONscrOLiElktMm0rccD5-4o6RurAoGEsbFXMZ7H52vK9MKjw>
    <xme:A5tfY4_cEweKdkZdyLpHggA4iqn1TwLehBmNGmuFat2gjMh4hXAOiHeXCDHexJKsr
    s99IZwS6Q_BZw>
X-ME-Received: <xmr:A5tfYxS70SgzOs00JXlkbTbu5xwh577lH8osFSjmk4T2HCdP6ZoOHB-jKhU5j_Rq6EagBk8lvB-X5JItl2TO3SwZO7eNoa_B>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvgedrudefgddtlecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepfffhvfevuffkfhggtggugfgjsehtke
    ertddttddunecuhfhrohhmpefirhgvghcumffjuceoghhrvghgsehkrhhorghhrdgtohhm
    qeenucggtffrrghtthgvrhhnpeelheehudduueeggeejgfehueduffehveeukefgkeeufe
    eltdejteeiuedtkeekleenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgr
    ihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:A5tfY6sLtOItAPf0OcWf0A8ZD6kyMUxZdgPtbOw4_KThim-BIAjhrg>
    <xmx:A5tfYydeDJGJUS-arQwZJX_NXaKyyfRQ7y3gPQtn_KBlR1UPH068Og>
    <xmx:A5tfY-28tf0-W5GoL7zQ5CfF0FdQAlJoy_5nRpGKRMnlM3BO5-1YAA>
    <xmx:A5tfY5yQdX2ZFGsEc7onxY765lLsH8ulLL4JMjjiIhLvDkuWlg35Kg>
Feedback-ID: i787e41f1:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 31 Oct 2022 05:53:06 -0400 (EDT)
Date:   Mon, 31 Oct 2022 10:53:58 +0100
From:   Greg KH <greg@kroah.com>
To:     Christian =?iso-8859-1?Q?L=F6hle?= <CLoehle@hyperstone.com>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "ulf.hansson@linaro.org" <ulf.hansson@linaro.org>,
        "adrian.hunter@intel.com" <adrian.hunter@intel.com>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>
Subject: Re: [PATCH] mmc: block: Remove error check of hw_reset on reset
Message-ID: <Y1+bNsOJK7kB0yBZ@kroah.com>
References: <0b965373ab0a4d35b0d98071a71fc304@hyperstone.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <0b965373ab0a4d35b0d98071a71fc304@hyperstone.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 31, 2022 at 09:39:53AM +0000, Christian Löhle wrote:
> commit 406e14808ee6 upstream
> 
> Before switching back to the right partition in mmc_blk_reset there used
> to be a check if hw_reset was even supported. This return value
> was removed, so there is no reason to check. Furthermore ensure
> part_curr is not falsely set to a valid value on reset or
> partition switch error.
> 
> As part of this change the code paths of mmc_blk_reset calls were checked
> to ensure no commands are issued after a failed mmc_blk_reset directly
> without going through the block layer.
> 
> Fixes: fefdd3c91e0a ("mmc: core: Drop superfluous validations in mmc_hw|sw_reset()")
> 
> Signed-off-by: Christian Loehle <cloehle@hyperstone.com>
> ---
>  drivers/mmc/core/block.c | 44 ++++++++++++++++++++++++----------------
>  1 file changed, 26 insertions(+), 18 deletions(-)

Now queued up, thanks.

greg k-h
