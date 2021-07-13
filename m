Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F29743C7807
	for <lists+stable@lfdr.de>; Tue, 13 Jul 2021 22:34:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231499AbhGMUg5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Jul 2021 16:36:57 -0400
Received: from mga05.intel.com ([192.55.52.43]:34297 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229944AbhGMUg5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 13 Jul 2021 16:36:57 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10044"; a="295883569"
X-IronPort-AV: E=Sophos;i="5.84,237,1620716400"; 
   d="scan'208";a="295883569"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jul 2021 13:34:07 -0700
X-IronPort-AV: E=Sophos;i="5.84,237,1620716400"; 
   d="scan'208";a="459711144"
Received: from smile.fi.intel.com (HELO smile) ([10.237.68.40])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jul 2021 13:34:04 -0700
Received: from andy by smile with local (Exim 4.94.2)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1m3P6N-00D4nw-8l; Tue, 13 Jul 2021 23:33:59 +0300
Date:   Tue, 13 Jul 2021 23:33:59 +0300
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Laurence Oberman <loberman@redhat.com>
Cc:     linux-usb@vger.kernel.org, stable@vger.kernel.org,
        emilne@redhat.com, djeffery@redhat.com, apanagio@redhat.com,
        torez@redhat.com
Subject: Re: [PATCH] usb: hcd: Revert
 306c54d0edb6ba94d39877524dddebaad7770cf2: Try MSI interrupts on PCI devices
Message-ID: <YO34tyvp/hkO+24F@smile.fi.intel.com>
References: <1626202242-14984-1-git-send-email-loberman@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1626202242-14984-1-git-send-email-loberman@redhat.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jul 13, 2021 at 02:50:42PM -0400, Laurence Oberman wrote:
> Customers have been reporting that the I/O is radically being
> slowed down to HPE virtual USB ILO served DVD images during installation.

Side note:

Simple changing

-		retval = pci_alloc_irq_vectors(dev, 1, 1, PCI_IRQ_LEGACY | PCI_IRQ_MSI);
+		retval = pci_alloc_irq_vectors(dev, 1, 1, PCI_IRQ_LEGACY);

should have the same effect without touching tons of a good code.

-- 
With Best Regards,
Andy Shevchenko


