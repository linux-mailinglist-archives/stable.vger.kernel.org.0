Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D5A3F13AAD9
	for <lists+stable@lfdr.de>; Tue, 14 Jan 2020 14:25:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728834AbgANNZE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jan 2020 08:25:04 -0500
Received: from icebox.esperi.org.uk ([81.187.191.129]:46326 "EHLO
        mail.esperi.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728682AbgANNZE (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Jan 2020 08:25:04 -0500
X-Greylist: delayed 3049 seconds by postgrey-1.27 at vger.kernel.org; Tue, 14 Jan 2020 08:25:03 EST
Received: from loom (nix@sidle.srvr.nix [192.168.14.8])
        by mail.esperi.org.uk (8.15.2/8.15.2) with ESMTP id 00ECYALQ026352;
        Tue, 14 Jan 2020 12:34:11 GMT
From:   Nix <nix@esperi.org.uk>
To:     Eric Wheeler <bcache@lists.ewheeler.net>
Cc:     Coly Li <colyli@suse.de>, linux-bcache@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] bcache: back to cache all readahead I/Os
References: <20200104065802.113137-1-colyli@suse.de>
        <alpine.LRH.2.11.2001062256450.2074@mx.ewheeler.net>
Emacs:  (setq software-quality (/ 1 number-of-authors))
Date:   Tue, 14 Jan 2020 12:34:11 +0000
In-Reply-To: <alpine.LRH.2.11.2001062256450.2074@mx.ewheeler.net> (Eric
        Wheeler's message of "Mon, 6 Jan 2020 22:57:40 +0000 (UTC)")
Message-ID: <87lfqa2p4s.fsf@esperi.org.uk>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-DCC--Metrics: loom 1480; Body=4 Fuz1=4 Fuz2=4
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 6 Jan 2020, Eric Wheeler spake thusly:

> On Sat, 4 Jan 2020, Coly Li wrote:
>
>> In year 2007 high performance SSD was still expensive, in order to
>> save more space for real workload or meta data, the readahead I/Os
>> for non-meta data was bypassed and not cached on SSD.

It's also because readahead data is more likely to be useless.

>> In now days, SSD price drops a lot and people can find larger size
>> SSD with more comfortable price. It is unncessary to bypass normal
>> readahead I/Os to save SSD space for now.

Doesn't this reduce the utility of the cache by polluting it with
unnecessary content? It seems to me that we need at least a *litle*
evidence that this change is beneficial. (I mean, it might be beneficial
if on average the data that was read ahead is actually used.)

What happens to the cache hit rates when this change has been running
for a while?
