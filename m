Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1C4565260E
	for <lists+stable@lfdr.de>; Tue, 20 Dec 2022 19:12:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229958AbiLTSMR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Dec 2022 13:12:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229703AbiLTSMQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Dec 2022 13:12:16 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C73218696;
        Tue, 20 Dec 2022 10:12:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=mQu+Me2Zll0UL7j/3P/n52Hs7DxCwP73ZIgzQwDiwlY=; b=lTJOAZQLu4JJ1jtQj6RldEOzvO
        Ail1xiWwwJhqpX4Ss1/tX3TP45Hd9xAJ1HbAF5G0mWRiYw1XgbPohwbMmwB5IotjNbJj0rom18WvN
        UKZI2wzAjoFkxDlbVx/CKPSBq+3bpSJneMgPK0s7d6oMTeA4BDXsZurwRsIF8fCTerd/vOGBET3de
        wgEp0Ym0fnfN562kZWOh9NaZQw2vFEw2SVbV+jq430SXYH+r30Y6ZywtboEfyMftkk3p11lITwsgA
        c2Zk34SvjAT+sBI/4YaZOGw3V+OFLjU+Kqo3m900uazcOt5EV/czwbhD9ZnOJA+IRTgIsrnaEWrNj
        U7yRi32A==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1p7h65-0020Ag-9h; Tue, 20 Dec 2022 18:12:13 +0000
Date:   Tue, 20 Dec 2022 10:12:13 -0800
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     Allen Webb <allenwebb@google.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-modules@vger.kernel.org" <linux-modules@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>, stable@vger.kernel.org,
        kernel test robot <lkp@intel.com>
Subject: Re: [PATCH v9 02/10] rockchip-mailbox: Fix typo
Message-ID: <Y6H6/U0w96Z4kpDn@bombadil.infradead.org>
References: <20221219191855.2010466-1-allenwebb@google.com>
 <20221219204619.2205248-1-allenwebb@google.com>
 <20221219204619.2205248-3-allenwebb@google.com>
 <Y6FaUynXTrYD6OYT@kroah.com>
 <CAJzde04Hbd2+s-Bqog2V81dBEeZD7WWaFCf2BkesQS4yUAKiNA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJzde04Hbd2+s-Bqog2V81dBEeZD7WWaFCf2BkesQS4yUAKiNA@mail.gmail.com>
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

On Tue, Dec 20, 2022 at 08:58:36AM -0600, Allen Webb wrote:
> As mentioned in a different sub-thread this cannot be built as a
> module so I updated the commit message to:
> 
> imx: Fix typo
>
> A one character difference in the name supplied to MODULE_DEVICE_TABLE
> breaks compilation for SOC_IMX8M after built-in modules can generate
> match-id based module aliases, so fix the typo.

Are you saying that it is a typo *now* only, and fixing it does not fix
compilation now, but that fixing the typo will fix a future compilation
issue once your patches get merged for built-in module aliases?

> This was not caught earlier because SOC_IMX8M can not be built as a
> module and MODULE_DEVICE_TABLE is a no-op for built-in modules.

Odd, so why did it use MODULE_DEVICE_TABLE then? What was the reason for
the driver having MODULE_DEVICE_TABLE if it was a no-op?

  Luis
