Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8484D6C1367
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 14:29:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231147AbjCTN3Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 09:29:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229762AbjCTN3Y (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 09:29:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16BED25E16
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 06:28:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3EFA1B80E87
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 13:28:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9B83C433EF;
        Mon, 20 Mar 2023 13:28:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679318919;
        bh=J9tT0Z0kcizEGp64qroQ5lL/kHeEmcb0s2y62vQGDng=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Bk3PowtJhcNlzlW2Rg4JfwiPSN94nxrY41GSLUTb8LfNEkaBgAtOGqRYeEvhPZcO2
         wwapGKKBYOrMvylHfWxQDdjBFtShK6CkrI1c7I0tmFoOc+Xslxzi+TS4/SBG7sqe07
         QvRNC3mOg2pRH8+5xE4i+/YMWIpnZfAAs6ZFUhls=
Date:   Mon, 20 Mar 2023 14:28:36 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Philip =?iso-8859-1?Q?M=FCller?= <philm@manjaro.org>
Cc:     John Harrison <John.C.Harrison@intel.com>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>,
        intel-gfx@lists.freedesktop.org, stable@vger.kernel.org
Subject: Re: [Regression] drm/i915: Don't use BAR mappings for ring buffers
 with LLC alone creates issues in stable kernels
Message-ID: <ZBhfhJ0ylxqXPHee@kroah.com>
References: <8a1bbe56-4463-d18d-d5a9-d249171a569d@manjaro.org>
 <a0be2b31-9e72-1254-978e-570b27abb364@manjaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a0be2b31-9e72-1254-978e-570b27abb364@manjaro.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Mar 19, 2023 at 10:01:01AM +0700, Philip Müller wrote:
> Have to correct the affected kernels to these: 4.14.310, 4.19.278, 5.4.237,
> 5.10.175

Please don't top-post :(

Anyway, should be fixed in the next round of releases in a few days, if
not, please let us know.

greg k-h
