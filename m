Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CAA7E6514C2
	for <lists+stable@lfdr.de>; Mon, 19 Dec 2022 22:23:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232444AbiLSVXL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Dec 2022 16:23:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229690AbiLSVXJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Dec 2022 16:23:09 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DE87DF84;
        Mon, 19 Dec 2022 13:23:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=BojGtvTf32ARfMwz4BQwWRfKsdgMPOlVK/P6QP9ISHo=; b=lPfupz9sQfcNAdc57/GQHfJRXj
        SUi9Ut0JgRQ/1IgCD5jL6qfi3q4eXK22s8zW01J8vl5jeSxm80SnyhiMugKySB8fkI9oSm27eKMOa
        89LI54WU4aQTgJK33H41XztGhPuy9V5OOER7cit9K8IDTUHMxFkpxU2xpBg4ESogIx22kD7aKkRTc
        +ZCeeMTxkVSTL5VwaINGX4t075gnr5hA8r30EO5QzEjiAcpn1Y+Hf/BrtLrKYAQusqxAeBOGs+H+w
        pBBfAIK7IqGqLP93KnCYWEneOWiLzjjnOwBVso0GwKS5A6yHNaClivE+6BN2lwaKtuLpZCfD+z2Ar
        ctluURyg==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1p7NbF-003uI0-U9; Mon, 19 Dec 2022 21:23:05 +0000
Date:   Mon, 19 Dec 2022 13:23:05 -0800
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     Allen Webb <allenwebb@google.com>
Cc:     "linux-modules@vger.kernel.org" <linux-modules@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>, stable@vger.kernel.org,
        kernel test robot <lkp@intel.com>
Subject: Re: [PATCH v9 01/10] imx: Fix typo
Message-ID: <Y6DWOdd3XtibtiLW@bombadil.infradead.org>
References: <20221219191855.2010466-1-allenwebb@google.com>
 <20221219204619.2205248-1-allenwebb@google.com>
 <20221219204619.2205248-2-allenwebb@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221219204619.2205248-2-allenwebb@google.com>
Sender: Luis Chamberlain <mcgrof@infradead.org>
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 19, 2022 at 02:46:09PM -0600, Allen Webb wrote:
> A one character difference in the name supplied to MODULE_DEVICE_TABLE
> breaks a future patch set, so fix the typo.

What behaviour is broken here for older kernels? What would not work
that makes this patch worthy of consideration for stable? The commit
log should be clear on that.

In the future, it may be useful for you to wait at least 1 week or so
before sending a new series becuase just a couple of days is not enough
if you are getting feedback.

So before sending a v10, please give it at least a few days or a week.

  Luis
