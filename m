Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFF5F5AC4A4
	for <lists+stable@lfdr.de>; Sun,  4 Sep 2022 16:09:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233715AbiIDOJf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 4 Sep 2022 10:09:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233625AbiIDOJe (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 4 Sep 2022 10:09:34 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24CC5A455
        for <stable@vger.kernel.org>; Sun,  4 Sep 2022 07:09:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C6BA4B80D7D
        for <stable@vger.kernel.org>; Sun,  4 Sep 2022 14:09:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17A83C433C1;
        Sun,  4 Sep 2022 14:09:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662300570;
        bh=Q8EqfaWnMEDNo2BaN/HlDF4gMdUzDupo21cS/wV0r40=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=i5NvmD720CRC+4CJO4Mwjwx3iJ23qOwA2P5HsyogpxuqzRGuD9NwBfTwWsvgX6E7i
         RH3JLq3P7MyIv4d3qqT5KcejlsSMoAAVWEEUSwsmBUtYmph+eI5BZ99fO2qFsFbCzL
         +vYFHQceh4Kb0/mLTKq7j3GQKS8ejDcTMxBf0K+M=
Date:   Sun, 4 Sep 2022 16:09:27 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     kernel test robot <lkp@intel.com>
Cc:     Jiri Olsa <jolsa@kernel.org>, stable@vger.kernel.org,
        kbuild-all@lists.01.org
Subject: Re: [PATCH stable 5.15 2/2] kbuild: Add skip_encoding_btf_enum64
 option to pahole
Message-ID: <YxSxl3lpcu7CuzYB@kroah.com>
References: <20220904131901.13025-3-jolsa@kernel.org>
 <YxSmMFXC1a02zBDn@876d715a1888>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YxSmMFXC1a02zBDn@876d715a1888>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Sep 04, 2022 at 09:20:48PM +0800, kernel test robot wrote:
> Hi,
> 
> Thanks for your patch.
> 
> FYI: kernel test robot notices the stable kernel rule is not satisfied.
> 
> Rule: 'Cc: stable@vger.kernel.org' or 'commit <sha1> upstream.'
> Subject: [PATCH stable 5.15 2/2] kbuild: Add skip_encoding_btf_enum64 option to pahole
> Link: https://lore.kernel.org/stable/20220904131901.13025-3-jolsa%40kernel.org
> 
> The check is based on https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html

Nice catch, but this one is ok :)
