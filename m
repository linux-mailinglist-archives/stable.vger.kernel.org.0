Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E6659551C2
	for <lists+stable@lfdr.de>; Tue, 25 Jun 2019 16:33:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730529AbfFYOdf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jun 2019 10:33:35 -0400
Received: from verein.lst.de ([213.95.11.211]:35427 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728710AbfFYOdf (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 25 Jun 2019 10:33:35 -0400
Received: by newverein.lst.de (Postfix, from userid 2407)
        id 971BE68B05; Tue, 25 Jun 2019 16:33:03 +0200 (CEST)
Date:   Tue, 25 Jun 2019 16:33:03 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Jinpu Wang <jinpu.wang@cloud.ionos.com>
Cc:     Christoph Hellwig <hch@lst.de>, Jack Wang <jinpuwang@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        sashal@kernel.org, stable <stable@vger.kernel.org>,
        "Darrick J . Wong" <darrick.wong@oracle.com>
Subject: Re: [stable-4.14 1/2] block: add a lower-level bio_add_page
 interface
Message-ID: <20190625143303.GA7202@lst.de>
References: <20190625141725.26220-1-jinpuwang@gmail.com> <20190625141725.26220-2-jinpuwang@gmail.com> <20190625142444.GA6993@lst.de> <CAMGffEmDt91QfOtbBm2AsRgb0JHW5pzOQeC_7TdX_v3XrW40qA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMGffEmDt91QfOtbBm2AsRgb0JHW5pzOQeC_7TdX_v3XrW40qA@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 25, 2019 at 04:27:44PM +0200, Jinpu Wang wrote:
> On Tue, Jun 25, 2019 at 4:25 PM Christoph Hellwig <hch@lst.de> wrote:
> >
> > Why does this patch warrant a stable backport?
> [jwang: cherry pick to 4.14, requred for next patch to build] :)

There was no next patch in my inbox..
