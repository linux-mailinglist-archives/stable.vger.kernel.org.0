Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 933FA3D4575
	for <lists+stable@lfdr.de>; Sat, 24 Jul 2021 08:59:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234102AbhGXGTZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 24 Jul 2021 02:19:25 -0400
Received: from verein.lst.de ([213.95.11.211]:40319 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229941AbhGXGTZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 24 Jul 2021 02:19:25 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 1A9ED67373; Sat, 24 Jul 2021 08:59:54 +0200 (CEST)
Date:   Sat, 24 Jul 2021 08:59:54 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     chaitanya.kulkarni@wdc.com, hch@lst.de, ira.weiny@intel.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        stable@vger.kernel.org, torvalds@linux-foundation.org
Subject: Re: [patch 06/15] mm: call flush_dcache_page() in memcpy_to_page()
 and memzero_page()
Message-ID: <20210724065954.GA2505@lst.de>
References: <20210723154926.c6cda0f262b1990b950a5886@linux-foundation.org> <20210723225017.xFO0jZesP%akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210723225017.xFO0jZesP%akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jul 23, 2021 at 03:50:17PM -0700, Andrew Morton wrote:
> one used the PC floppy dr\u0456ver, the aha1542 driver for an ISA SCSI

Looks like I produced some messed up utf8 chars again - the above garbage
should read "driver" of course.
