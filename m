Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B8494B5336
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 15:25:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347446AbiBNOZO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 09:25:14 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:58186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230516AbiBNOZN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 09:25:13 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC8544A906;
        Mon, 14 Feb 2022 06:25:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=+N8sYBj1l7vLV3pVXWOrmvpsGB19dwrA9moQCEYQRTc=; b=QKy0CmMZ9kzH7RdLpCDCfGY5yT
        CL4Fph5u5q/b66wYVhjJdVymYcoPCZ8e34fwwdKMTNjC7bothgyt+vmNEcKlOsErLkD3sRoZQdFUJ
        +ibISaQLqrjOxca0/SPrFSXdeJYTuoFK2DhOj3wowqfr8alXlxSHdTS8vEpq7r2kUWtJACpTa4ZDz
        W+9rpYCnD0TNjXyiZFzerm8s6KUS+pxL5+RneuqnjXakcKLkqBJQGhx+v6SOt47COQgJqxN602pij
        86CTpkFihVRil2YEvju6MlX5W1FM59DmcIE0AX6xJkY/alXqETno1oTeBdJwy9nmMGgninjKl14zO
        VUjZ79bQ==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nJcHf-00Cyyq-By; Mon, 14 Feb 2022 14:24:55 +0000
Date:   Mon, 14 Feb 2022 14:24:55 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     Lee Jones <lee.jones@linaro.org>
Cc:     Christoph Hellwig <hch@lst.de>,
        "Darrick J. Wong" <djwong@kernel.org>,
        linux-kernel@vger.kernel.org, Stable <stable@vger.kernel.org>,
        Dave Chinner <dchinner@redhat.com>,
        Goldwyn Rodrigues <rgoldwyn@suse.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        Bob Peterson <rpeterso@redhat.com>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Theodore Ts'o <tytso@mit.edu>,
        Andreas Gruenbacher <agruenba@redhat.com>,
        Ritesh Harjani <riteshh@linux.ibm.com>,
        Johannes Thumshirn <jth@kernel.org>, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        cluster-devel@redhat.com,
        syzbot+0ed9f769264276638893@syzkaller.appspotmail.com
Subject: Re: [PATCH 1/1] Revert "iomap: fall back to buffered writes for
 invalidation failures"
Message-ID: <YgpmN/R7jAf97PBU@casper.infradead.org>
References: <20220209085243.3136536-1-lee.jones@linaro.org>
 <20220210045911.GF8338@magnolia>
 <YgTl2Lm9Vk50WNSj@google.com>
 <YgZ0lyr91jw6JaHg@casper.infradead.org>
 <YgowAl01rq5A8Sil@google.com>
 <20220214134206.GA29930@lst.de>
 <YgpjIustbUeRqvR2@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YgpjIustbUeRqvR2@google.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 14, 2022 at 02:11:46PM +0000, Lee Jones wrote:
> On Mon, 14 Feb 2022, Christoph Hellwig wrote:
> 
> > Let me repeat myself:  Please send a proper bug report to the linux-ext4
> > list.  Thanks!
> 
> Okay, so it is valid.  Question answered, thanks.
> 
> I still believe that I am unqualified to attempt to debug this myself.

Nobody's asking you to debug it yourself.  We're asking you to
file a clear bug report instead of wasting everybody's time.
