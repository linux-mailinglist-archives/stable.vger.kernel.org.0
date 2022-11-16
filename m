Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CB2462CF2C
	for <lists+stable@lfdr.de>; Thu, 17 Nov 2022 00:55:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234393AbiKPXzC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Nov 2022 18:55:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233886AbiKPXzB (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Nov 2022 18:55:01 -0500
Received: from wout1-smtp.messagingengine.com (wout1-smtp.messagingengine.com [64.147.123.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C339066C9E;
        Wed, 16 Nov 2022 15:55:00 -0800 (PST)
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id 8FBA832003C0;
        Wed, 16 Nov 2022 18:54:59 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Wed, 16 Nov 2022 18:55:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
         h=cc:cc:content-type:date:date:from:from:in-reply-to
        :in-reply-to:message-id:mime-version:references:reply-to:sender
        :subject:subject:to:to; s=fm2; t=1668642899; x=1668729299; bh=E6
        JF0cEeUYzVPtpcCWq54L+1lUQkLjUmOjkjEOpTZQs=; b=HxYk+rY3975eYJAPSW
        Ph7ZU1IwAnV4TanjbmZUbDB6VzD/zAZfucXLQXGfvHyoibQO0lD1E2qcwXsf3Alp
        7PPDHs2Y7WKoBapqB+/iV0/iTm0RXFCMrsgHaag5LHGYqbiLx/IuUsTwkZsCbBRG
        0Z3zd3w0NkBhAfzrNz8A/8Ll+OU1CmIwCLOtNvkPGmvh7+EjfSFMHTGC7Xjqz3Wn
        wi7vbkyOHminV0tsPsCiMU3LBwZeDZ9ErNMA4tICmPEqmoCe6R+Ei1yI4avkZ9wy
        leIpyBk4x1WB7nUXHJu1FP4KLZZ+rVhChhJNTuarphOpvXAIlq4Vknwov//y13RI
        s8sg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; t=1668642899; x=1668729299; bh=E6JF0cEeUYzVPtpcCWq54L+1lUQk
        LjUmOjkjEOpTZQs=; b=G07M2l3GSh3PLRpUpbkrFfJDVMCtKW0iGwiKO8yVW688
        ZPOucYUGnER+7H6ToVIvXVQDpXtrNMor5uRwNLLAKXFG9fk5/97wq7YoI0/rNtLd
        IWWocrNz3QIS/18Ltl2wAuGImJe8BZizYkyzEoz29+wFZBwXrrjnnY4Vw+5naKL/
        1QQ9Ol7iYPlEtwt+C0WBLRenclkgXHuCJvxo3anJr/aJmTRWP7Q/9ujfOd8KSnjl
        VABLD32s5ltm4PfAvK7gBzffZyDqQTO9BFVPARHIElY2Gu5jV0YDLka5u6YlmMFL
        0kUe9ac6M5uXZ4U43WwFBojxgvm5W+DQNIGNHJaJLw==
X-ME-Sender: <xms:Unh1Y854ORzk8SFRgynH9lD4k_-BLpT6Vg3ODpSR1Vcs_p_sVrMZyg>
    <xme:Unh1Y96f3_BXmDZJ0FjEkx0fsO4UhHjD3_O2O04XZdLpFg-nlIP5BwgDJD9SA1yLv
    zBCtXTsXwOrwcxKrSY>
X-ME-Received: <xmr:Unh1Y7fd4FQnxXfNnAs_lVR-Ad9HbRsJXxBHKEG-UNlH3z-s5DLQ-AdYoRnBPYubNhnp3A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvgedrgeejgdduiecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvvefukfhfgggtuggjsehttddttddttddvnecuhfhrohhmpedfmfhirhhi
    lhhlucetrdcuufhhuhhtvghmohhvfdcuoehkihhrihhllhesshhhuhhtvghmohhvrdhnrg
    hmvgeqnecuggftrfgrthhtvghrnhephfeigefhtdefhedtfedthefghedutddvueehtedt
    tdehjeeukeejgeeuiedvkedtnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpe
    hmrghilhhfrhhomhepkhhirhhilhhlsehshhhuthgvmhhovhdrnhgrmhgv
X-ME-Proxy: <xmx:Unh1YxI9iIYdKgHxx2SGafkvR7A5ElwzVHFEn0Dgj5n8wQrEVljFbw>
    <xmx:Unh1YwLxu9M0RFU14x20Qo__UDf-WabQX-f-fkbHcvELqCyBSXadCA>
    <xmx:Unh1YywGTGww3BJL_IVBSnir7p7Ut6GxjQPE6OWW3E-wURkQ0M9CNg>
    <xmx:U3h1Y1XGTsKaY2E1nHo6LGGHZAd7Gxgkw29BGhfWxjRD5Qq8EuHuRQ>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 16 Nov 2022 18:54:58 -0500 (EST)
Received: by box.shutemov.name (Postfix, from userid 1000)
        id 9E6CC109702; Thu, 17 Nov 2022 02:54:55 +0300 (+03)
Date:   Thu, 17 Nov 2022 02:54:55 +0300
From:   "Kirill A. Shutemov" <kirill@shutemov.name>
To:     Vishal Verma <vishal.l.verma@intel.com>
Cc:     "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        linux-kernel@vger.kernel.org,
        Chris Piper <chris.d.piper@intel.com>, nvdimm@lists.linux.dev,
        linux-acpi@vger.kernel.org,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Liu Shixin <liushixin2@huawei.com>, stable@vger.kernel.org
Subject: Re: [PATCH v2 2/2] ACPI: HMAT: Fix initiator registration for
 single-initiator systems
Message-ID: <20221116235455.74nqyfdcqe72mhbi@box.shutemov.name>
References: <20221116-acpi_hmat_fix-v2-0-3712569be691@intel.com>
 <20221116-acpi_hmat_fix-v2-2-3712569be691@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221116-acpi_hmat_fix-v2-2-3712569be691@intel.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 16, 2022 at 04:37:37PM -0700, Vishal Verma wrote:
> In a system with a single initiator node, and one or more memory-only
> 'target' nodes, the memory-only node(s) would fail to register their
> initiator node correctly. i.e. in sysfs:
> 
>   # ls /sys/devices/system/node/node0/access0/targets/
>   node0
> 
> Where as the correct behavior should be:
> 
>   # ls /sys/devices/system/node/node0/access0/targets/
>   node0 node1
> 
> This happened because hmat_register_target_initiators() uses list_sort()
> to sort the initiator list, but the sort comparision function
> (initiator_cmp()) is overloaded to also set the node mask's bits.
> 
> In a system with a single initiator, the list is singular, and list_sort
> elides the comparision helper call. Thus the node mask never gets set,
> and the subsequent search for the best initiator comes up empty.
> 
> Add a new helper to consume the sorted initiator list, and generate the
> nodemask, decoupling it from the overloaded initiator_cmp() comparision
> callback. This prevents the singular list corner case naturally, and
> makes the code easier to follow as well.
> 
> Cc: <stable@vger.kernel.org>
> Cc: Rafael J. Wysocki <rafael@kernel.org>
> Cc: Liu Shixin <liushixin2@huawei.com>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> Reported-by: Chris Piper <chris.d.piper@intel.com>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>

Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>

-- 
  Kiryl Shutsemau / Kirill A. Shutemov
