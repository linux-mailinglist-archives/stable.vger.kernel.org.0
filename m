Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B5384569EB
	for <lists+stable@lfdr.de>; Fri, 19 Nov 2021 07:09:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232972AbhKSGMW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Nov 2021 01:12:22 -0500
Received: from verein.lst.de ([213.95.11.211]:49923 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231166AbhKSGMU (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Nov 2021 01:12:20 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id C8F5668AFE; Fri, 19 Nov 2021 07:09:15 +0100 (CET)
Date:   Fri, 19 Nov 2021 07:09:15 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Kees Cook <keescook@chromium.org>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Anton Vorontsov <anton@enomsg.org>,
        Colin Cross <ccross@android.com>,
        Tony Luck <tony.luck@intel.com>, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org
Subject: Re: [PATCH] pstore/blk: Use "%lu" to format unsigned long
Message-ID: <20211119060915.GB15001@lst.de>
References: <20211118182621.1280983-1-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211118182621.1280983-1-keescook@chromium.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
