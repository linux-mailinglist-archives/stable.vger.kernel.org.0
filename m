Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A188A61C5
	for <lists+stable@lfdr.de>; Tue,  3 Sep 2019 08:50:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726062AbfICGuL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Sep 2019 02:50:11 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:44968 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726053AbfICGuL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Sep 2019 02:50:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=wDAicFjVrqvRiLBg0KBDH0Vwt5aH3GKjpzdO4BtXzH0=; b=sZFcdOJsYz6De6oed/+j0vHkJ
        yyBVrEke53E8gQClnChkWR6mKVb8ZTdFreg0DLR0TsH8YL+o96fLWMIQNPCN4yDUz0kiAXIUEzmJM
        U6va1LKR526+ngiF/VqOTLMm3lV+Su7G6e3yq+QHJ6/STGvwTY6qABL0YUXzHBJcgY9Y7IQVQUR/Q
        8S2aNrz+BdS+0Em8X1LPeoOPPzn8H7iWJ4uL+KmVPiJjGFoCdBW2QWxi/EhmuKMHLd+qU0Inbt8/0
        81/d1CaohrvJM2NT9PUXuLRwquPoxpT0+2HQk9NB5wKJqW8pKIGXdaYLNV80078oemej5U92zihQx
        WFe0VrPLA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat Linux))
        id 1i52di-0006eH-8n; Tue, 03 Sep 2019 06:50:06 +0000
Date:   Mon, 2 Sep 2019 23:50:06 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Mike Travis <mike.travis@hpe.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>,
        Dimitri Sivanich <dimitri.sivanich@hpe.com>,
        Russ Anderson <russ.anderson@hpe.com>,
        Hedi Berriche <hedi.berriche@hpe.com>,
        Steve Wahl <steve.wahl@hpe.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 5/8] x86/platform/uv: Add UV Hubbed/Hubless Proc FS Files
Message-ID: <20190903065006.GB9914@infradead.org>
References: <20190903001815.504418099@stormcage.eag.rdlabs.hpecorp.net>
 <20190903001816.288373651@stormcage.eag.rdlabs.hpecorp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190903001816.288373651@stormcage.eag.rdlabs.hpecorp.net>
User-Agent: Mutt/1.11.4 (2019-03-13)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> +extern int _is_uv_hubbed(int uvtype);
> +#define is_uv_hubbed _is_uv_hubbed

> +static inline int _is_uv_hubbed(int uv)	{ return 0; }
> +#define is_uv_hubbed _is_uv_hubbed

Another two instances of these weird indirections..
