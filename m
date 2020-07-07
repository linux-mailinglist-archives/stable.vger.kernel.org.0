Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 828AE2166E7
	for <lists+stable@lfdr.de>; Tue,  7 Jul 2020 08:57:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728249AbgGGG5U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jul 2020 02:57:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:44778 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726788AbgGGG5U (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jul 2020 02:57:20 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 96CAE206E9;
        Tue,  7 Jul 2020 06:57:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594105039;
        bh=bhpKlvwim1fVN7Nr9utrslL9C71fMybXOu7IHiu12ZY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Sv9azsodDdkbgvmgClRu8annhzLJ713NZmUNor3hMgN/ovHsD6ze+jFAhOi3SJn7C
         3hJdOkh1jmNQuzTyMkJDCLmIDDh29V89izDTDKzMyFeCT00XcFNAmSVoC2CB249Ecq
         PbG+rfd6l4/c6bWi7Z0mln5YApw3m/BIBITKuEwY=
Date:   Tue, 7 Jul 2020 08:57:16 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Rajat Jain <rajatja@google.com>
Cc:     David Woodhouse <dwmw2@infradead.org>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Joerg Roedel <joro@8bytes.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Len Brown <lenb@kernel.org>, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org, Raj Ashok <ashok.raj@intel.com>,
        lalithambika.krishnakumar@intel.com,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Prashant Malani <pmalani@google.com>,
        Benson Leung <bleung@google.com>,
        Todd Broch <tbroch@google.com>,
        Alex Levin <levinale@google.com>,
        Mattias Nissler <mnissler@google.com>,
        Rajat Jain <rajatxjain@gmail.com>,
        Bernie Keany <bernie.keany@intel.com>,
        Aaron Durbin <adurbin@google.com>,
        Diego Rivas <diegorivas@google.com>,
        Duncan Laurie <dlaurie@google.com>,
        Furquan Shaikh <furquan@google.com>,
        Jesse Barnes <jsbarnes@google.com>,
        Christian Kellner <christian@kellner.me>,
        Alex Williamson <alex.williamson@redhat.com>, oohall@gmail.com,
        Saravana Kannan <saravanak@google.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH RESEND v2] PCI: Add device even if driver attach failed
Message-ID: <20200707065716.GA5622@kroah.com>
References: <20200706233240.3245512-1-rajatja@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200706233240.3245512-1-rajatja@google.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 06, 2020 at 04:32:40PM -0700, Rajat Jain wrote:
> device_attach() returning failure indicates a driver error while trying to
> probe the device. In such a scenario, the PCI device should still be added
> in the system and be visible to the user.
> 
> This patch partially reverts:
> commit ab1a187bba5c ("PCI: Check device_attach() return value always")
> 
> Signed-off-by: Rajat Jain <rajatja@google.com>
> Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
> Resending to stable, independent from other patches per Greg's suggestion
> v2: Add Greg's reviewed by, fix commit log

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
