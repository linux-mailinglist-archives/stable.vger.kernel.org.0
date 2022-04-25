Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8082250DBCE
	for <lists+stable@lfdr.de>; Mon, 25 Apr 2022 10:57:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237177AbiDYJAS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Apr 2022 05:00:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230087AbiDYJAP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Apr 2022 05:00:15 -0400
Received: from wout1-smtp.messagingengine.com (wout1-smtp.messagingengine.com [64.147.123.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBACC63D8;
        Mon, 25 Apr 2022 01:57:07 -0700 (PDT)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 396B13200E79;
        Mon, 25 Apr 2022 04:57:03 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Mon, 25 Apr 2022 04:57:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm1; t=1650877022; x=1650963422; bh=jjab8bGcXC
        tNVAOVMvXLVzO2xI8lhzCj4Yq0VclOquo=; b=lGr9po7cUVaHSjl7HwN/6wVH9e
        L7sgZzoWcLsRs2HzCQzhVruD8giJJgAEhYm0bqe/l3F2tpqFXksw/VdPOiSXFkVc
        F1bRiNMbMEi1XV+qP915FDoBbBvjZMEaGDd+2QqyNmt9jmPzpnV7YCicVoZJmDyn
        8jRhQcMlKFIQuTx0yp04XFZs69tC5Mp2HTQNXepOicVUtnpLHyZq4yj7ak9ao/J6
        T4dEaeUz+C2YlnHjqknBMKYibPg2mqqVFhLHQCgZhKVMQdYuIarRKvDNRuMIX129
        f9jsbJvXW+TJqq3kIf2EQlkrysmcz/yt9FhnQbw5vqAePqGqLtVbF5gG494Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1650877022; x=
        1650963422; bh=jjab8bGcXCtNVAOVMvXLVzO2xI8lhzCj4Yq0VclOquo=; b=l
        LcpYECNCjrDzsL0CbPv+qi+rW1LX2CnBc1fKIHVh2VURCus8BeUfrQ/ILBbbdpcF
        MtB+6NMc7ZdOudAGj12rEJ8VDnDFghXXTu11SVPWW8VaA2vO0BlMoyEo27n5OTEu
        FuMGJrzGQUOcCC5D+ydo6aIs9fl8f+mRynBRC2FqtDPjnkzezqa1jVXeKWXTfoqN
        4qx9qdPSv6jyEwTRgVC0BHVdbCRxjDxL3EyxH1Y1hBGIuH83h6ldZwWgIRsD6vTs
        O82KGK7PKSw3Kl8XC3Xz/RoyK88CMTXP91Dlm/1HyWBpVnTrt2edgSq/9Jn93SFc
        npKPWcEd+PjjhuKU5VDwg==
X-ME-Sender: <xms:XmJmYlHeUZu3LGPPmk40s5RLcoZ7W7IajN0ohWLklNe6zIXKiajhuQ>
    <xme:XmJmYqWKOii65KNE4vg_yI-_3CjtB4g3_J7--r_WFrYo59ZbPcuXx4wZID2HHrp5O
    wOBB2SSeV0Luw>
X-ME-Received: <xmr:XmJmYnKe-ZaiLG54i4xxDlLQO0N3On5zvmv_1k-aLMCRwZn9vfPAj8flDDs_Ax_w8okhC5Azwtxvw1pIbo6N_ev_XrhtrF9S>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedruddugddtkecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvvefukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeehgedvve
    dvleejuefgtdduudfhkeeltdeihfevjeekjeeuhfdtueefhffgheekteenucevlhhushht
    vghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:XmJmYrFOnr64ORQ5FTauihsRBkrKmy-qQjRBbfu5g1U36wRSTXqCDA>
    <xmx:XmJmYrVLiqmAJzPm_ij1lQ3X8w4Ed702Ec-ZFiZSOP-ZKU4ke-PZaw>
    <xmx:XmJmYmN2qbG8WTpyai_Y4vKUCIlp5XuCUp5eBcGolMDdNCnzI_JBLA>
    <xmx:XmJmYvkmg_ZQbVQhY95LS2OzroLOwwlnxDDGn7ot_hXOxNK-J10xeA>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 25 Apr 2022 04:57:01 -0400 (EDT)
Date:   Mon, 25 Apr 2022 10:56:59 +0200
From:   Greg KH <greg@kroah.com>
To:     Akilesh Kailash <akailash@google.com>
Cc:     stable@vger.kernel.org, Jiazi Li <lijiazi@xiaomi.com>,
        kernel-team@android.com, Jiazi Li <jqqlijiazi@gmail.com>,
        Mike Snitzer <snitzer@redhat.com>,
        Alasdair Kergon <agk@redhat.com>, dm-devel@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dm: fix mempool NULL pointer race when completing IO
Message-ID: <YmZiW0TUSjxrEGGZ@kroah.com>
References: <20220425082812.780445-1-akailash@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220425082812.780445-1-akailash@google.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 25, 2022 at 08:28:12AM +0000, Akilesh Kailash wrote:
> From: Jiazi Li <jqqlijiazi@gmail.com>
> 
> commit d208b89401e073de986dc891037c5a668f5d5d95 upstream.
> 
> This is a backport of the upstream patch to 5.10.y stable branch.

Now queued up, thanks.

greg k-h
