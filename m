Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49CD9516EF4
	for <lists+stable@lfdr.de>; Mon,  2 May 2022 13:39:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232781AbiEBLnL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 May 2022 07:43:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232611AbiEBLnK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 May 2022 07:43:10 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5903515FDF;
        Mon,  2 May 2022 04:39:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 15528B81657;
        Mon,  2 May 2022 11:39:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9598FC385AF;
        Mon,  2 May 2022 11:39:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651491579;
        bh=WSHwriL2NKIWz7/ayg94uts9h/We1ZDjIIHGMTCDU1Y=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FYaSw7qVeQY/1RjtQHtZyPreRSSvo1ycGJh3qjZdzr/A5eZKYaMBHWrjuLfc9i/2F
         4CALcNjkcxrF3NhvN73aoGSSIx2KQyIBPliS9iiZqpyfBSm+TkRwIiHPPvlb0QThky
         gJI8vxI9Aa3RnD6NmT+8zqmcdTr2uR4ypYYKl+gQ=
Date:   Mon, 2 May 2022 13:39:38 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Hector Martin <marcan@marcan.st>
Cc:     Marc Zyngier <maz@kernel.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Rob Herring <robh@kernel.org>,
        Krzysztof =?utf-8?Q?Wilczy=C5=84ski?= <kw@linux.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Alyssa Rosenzweig <alyssa@rosenzweig.io>,
        Sven Peter <sven@svenpeter.dev>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 1/3] PCI: apple: GPIO handling nitfixes
Message-ID: <Ym/C+iFmWIEPrv8y@kroah.com>
References: <20220502093832.32778-1-marcan@marcan.st>
 <20220502093832.32778-2-marcan@marcan.st>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220502093832.32778-2-marcan@marcan.st>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 02, 2022 at 06:38:30PM +0900, Hector Martin wrote:
> - Use devm managed GPIO getter
> - GPIO ops can sleep in this context

Please read the section entitled "The canonical patch format" in the
kernel file, Documentation/SubmittingPatches for what is needed in order
to properly describe the change.  This text does not make any sense.

Same for your subject, it needs to be reworked.

thanks,

greg k-h
