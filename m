Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC48553ECC5
	for <lists+stable@lfdr.de>; Mon,  6 Jun 2022 19:13:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229621AbiFFRNI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Jun 2022 13:13:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229606AbiFFRMt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Jun 2022 13:12:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 376C336698;
        Mon,  6 Jun 2022 10:01:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DDE65B81AA9;
        Mon,  6 Jun 2022 17:01:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB075C34115;
        Mon,  6 Jun 2022 17:01:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654534911;
        bh=bJD/fja5F3nzWc5tv79q4pe1cOD2E1EH6I1G6LGpV6k=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HxG63xL3CFNrxcL50xJDr6nNVAtdtIGwvf8TgmeCMLSqsTfLMVt/hztO8qWlEYhOG
         RlLDLyknhJmLyJvdLYLAzsCLyg8UV1Di01cSCMbULZBLyBPytOv9UFUlYJrQmRyplz
         yWdiK+bSg+YKUJccqjalA1pkLUKzPtoeW14Z8SJA=
Date:   Mon, 6 Jun 2022 19:01:48 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Sasha Levin <sashal@kernel.org>,
        Dave Chinner <david@fromorbit.com>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Brian Foster <bfoster@redhat.com>,
        Christian Brauner <brauner@kernel.org>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Leah Rumancik <leah.rumancik@gmail.com>,
        Adam Manzanares <a.manzanares@samsung.com>,
        linux-xfs@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 v2 0/8] xfs fixes for 5.10.y (part 2)
Message-ID: <Yp4y/A5VCo7h3hb1@kroah.com>
References: <20220606143255.685988-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220606143255.685988-1-amir73il@gmail.com>
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 06, 2022 at 05:32:47PM +0300, Amir Goldstein wrote:
> Hi Greg,
> 
> This is the 2nd round of xfs fixes for 5.10.y.

All now queued up, thanks.

greg k-h
