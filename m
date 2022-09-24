Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52C8C5E8B00
	for <lists+stable@lfdr.de>; Sat, 24 Sep 2022 11:40:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233420AbiIXJkZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 24 Sep 2022 05:40:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233491AbiIXJkY (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 24 Sep 2022 05:40:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C6C4543F5;
        Sat, 24 Sep 2022 02:40:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EDD6360F63;
        Sat, 24 Sep 2022 09:40:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E1A4C433D6;
        Sat, 24 Sep 2022 09:40:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664012422;
        bh=ovz1BWAtP379YEthLT2B3puWxGJxMVJ0/EfX0WD8G80=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GRFVONMRvnSySH5rsKV/oBay1Goq9Y9PBOqcOIgYsmqlSV3OeGeflt5ej4owZGxxC
         AOlF8q7VOKH2AfBdyZdJS/qOlch5l0T1gLW+1zVaY7N9UGjspj9tEfV0h61xpYydLH
         4gDKo9eR91EYQrnTIMttnfMhygEQXzLFX5EZtn7Y=
Date:   Sat, 24 Sep 2022 11:40:20 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Leah Rumancik <leah.rumancik@gmail.com>
Cc:     stable@vger.kernel.org, linux-xfs@vger.kernel.org,
        amir73il@gmail.com, chandan.babu@oracle.com
Subject: Re: [PATCH 5.15 v2 0/3] xfs stable candidate patches (part 5)
Message-ID: <Yy7QhGyFszlSBGKR@kroah.com>
References: <20220922151501.2297190-1-leah.rumancik@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220922151501.2297190-1-leah.rumancik@gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Sep 22, 2022 at 08:14:58AM -0700, Leah Rumancik wrote:
> Hi Greg,
> 
> These patches correspond to the last two patches from the 5.10 series
> [1]. These patches were postponed for 5.10 until they were tested on
> 5.15. I have tested these on 5.15 (40 runs of the auto group x 4
> configs).

Now queued up, thanks.

greg k-h
