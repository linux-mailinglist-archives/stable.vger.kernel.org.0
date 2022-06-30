Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E502561904
	for <lists+stable@lfdr.de>; Thu, 30 Jun 2022 13:23:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234730AbiF3LXL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jun 2022 07:23:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232664AbiF3LXK (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Jun 2022 07:23:10 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3373063E0;
        Thu, 30 Jun 2022 04:23:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D0D16B82989;
        Thu, 30 Jun 2022 11:23:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AD42C34115;
        Thu, 30 Jun 2022 11:23:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656588186;
        bh=tyaYgozRPivqv2n7X+moCo4v7tfaFCNVhF3NOtVWKv4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hPNYMQjqCzoFA70JUy6vUrT3LG82X+HfpUHQqpkE25sFi6ASL+z/KKbR7LkWk8sL9
         3xQKd2Gcoo3efh/yYEXFZ/b+Z3Xl5VAdrCw9oScCo8/J5Y7mTbkvjjVfUFHFn38dfg
         925355suvDzB064bq+lstamp8TJmD/+evpepYIOA=
Date:   Thu, 30 Jun 2022 13:22:43 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Leah Rumancik <leah.rumancik@gmail.com>
Cc:     stable@vger.kernel.org, linux-xfs@vger.kernel.org,
        amir73il@gmail.com
Subject: Re: [PATCH 5.15 v4 0/7] xfs stable patches for 5.15.y
Message-ID: <Yr2Hg6k1U4JVG8kO@kroah.com>
References: <20220628183951.3425528-1-leah.rumancik@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220628183951.3425528-1-leah.rumancik@gmail.com>
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 28, 2022 at 11:39:44AM -0700, Leah Rumancik wrote:
> Hi Greg and Sasha,
> 
> This is the 5.15.y series corresponding to the 5.10.y set that Amir
> recently sent out [1]. These patches have been tested on both 5.10.y
> and 5.15.y with no regressions found. This series has been ACK'ed by
> the XFS developers for 5.15.y and are ready for 5.15 stable.

All now queued up, thanks.

greg k-h
