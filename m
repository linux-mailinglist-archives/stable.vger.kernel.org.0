Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D60237348B
	for <lists+stable@lfdr.de>; Wed,  5 May 2021 07:08:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229653AbhEEFJb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 May 2021 01:09:31 -0400
Received: from verein.lst.de ([213.95.11.211]:41518 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231663AbhEEFJb (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 May 2021 01:09:31 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id CF8DF68AFE; Wed,  5 May 2021 07:08:22 +0200 (CEST)
Date:   Wed, 5 May 2021 07:08:22 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Marc Orr <marcorr@google.com>
Cc:     Jianxiong Gao <jxgao@google.com>, stable@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>, sashal@kernel.org
Subject: Re: [PATCH v2 5.10 0/9] preserve DMA offsets when using swiotlb
Message-ID: <20210505050822.GA12134@lst.de>
References: <20210429173315.1252465-1-jxgao@google.com> <CAA03e5F5iVA2VYyN7=+XmXA1gHDiOhGNAOYrM3F9KBBfEJ1s7A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAA03e5F5iVA2VYyN7=+XmXA1gHDiOhGNAOYrM3F9KBBfEJ1s7A@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 04, 2021 at 01:22:14PM -0700, Marc Orr wrote:
> Christoph, are you OK with backporting this patch set to LTS, based on
> the rationale in the cover letter above?

I don't object, but I really do not have time to review it in detail.
