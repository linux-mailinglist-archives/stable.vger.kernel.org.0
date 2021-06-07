Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CD3739DA78
	for <lists+stable@lfdr.de>; Mon,  7 Jun 2021 13:00:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231224AbhFGLCV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Jun 2021 07:02:21 -0400
Received: from verein.lst.de ([213.95.11.211]:45664 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230520AbhFGLCV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 7 Jun 2021 07:02:21 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 6BD7367373; Mon,  7 Jun 2021 13:00:25 +0200 (CEST)
Date:   Mon, 7 Jun 2021 13:00:25 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Coly Li <colyli@suse.de>
Cc:     axboe@kernel.dk, linux-bcache@vger.kernel.org,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alexander Ullrich <ealex1979@gmail.com>,
        Diego Ercolani <diego.ercolani@gmail.com>,
        Jan Szubiak <jan.szubiak@linuxpolska.pl>,
        Marco Rebhan <me@dblsaiko.net>,
        Matthias Ferdinand <bcache@mfedv.net>,
        Victor Westerhuis <victor@westerhu.is>,
        Vojtech Pavlik <vojtech@suse.cz>,
        Rolf Fokkens <rolf@rolffokkens.nl>,
        Thorsten Knabe <linux@thorsten-knabe.de>,
        stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Kent Overstreet <kent.overstreet@gmail.com>,
        Nix <nix@esperi.org.uk>, Takashi Iwai <tiwai@suse.com>
Subject: Re: [PATCH v5 1/2] bcache: remove bcache device self-defined
 readahead
Message-ID: <20210607110025.GA6729@lst.de>
References: <20210607103539.12823-1-colyli@suse.de> <20210607103539.12823-2-colyli@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210607103539.12823-2-colyli@suse.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
