Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 198686BAF71
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 12:41:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231168AbjCOLll (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 07:41:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230492AbjCOLlk (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 07:41:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B64776059
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 04:41:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 311FA61D28
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 11:41:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42CC2C433EF;
        Wed, 15 Mar 2023 11:41:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678880498;
        bh=K98jGgFyp/bseulfRoW6tISoZK3zC8gO/ZooHlA9Gy0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=0N7TWVL+q3OoYIf4hOglpFRtA8nM9aJmtT1Kz1YVAk7BQZdVvhahcCuVZZ8yIa5cN
         HP+MOL/XON1jYE5YTxBsbaAuiaG1NvNnGRMzan6NcJfxoT+31KN3vAaRxdkwkCdQfj
         ywOkFeN3VK8yw94ZnXq8PP8IQeCiMy4IgsQqB2IQ=
Date:   Wed, 15 Mar 2023 12:41:25 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Alexandru Matei <alexandru.matei@uipath.com>
Cc:     stable@vger.kernel.org, Mihai Petrisor <mihai.petrisor@uipath.com>,
        Viorel Canja <viorel.canja@uipath.com>
Subject: Re: [PATCH 5.15.y v2 0/3] Stable backport for KVM-on-HyperV fix
Message-ID: <ZBGu5TEQixmZkYFy@kroah.com>
References: <20230315090656.4258-1-alexandru.matei@uipath.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230315090656.4258-1-alexandru.matei@uipath.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 15, 2023 at 11:06:53AM +0200, Alexandru Matei wrote:
> Hi folks,
> 
> Here are the backports for enlightened MSR bitmap fix and two prerequisite
> patches.
> 
> v2: signed the commits

All now queued up, thanks.

greg k-h
