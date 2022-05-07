Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10AE851E5AC
	for <lists+stable@lfdr.de>; Sat,  7 May 2022 10:45:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1446115AbiEGItF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 7 May 2022 04:49:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1446110AbiEGItA (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 7 May 2022 04:49:00 -0400
Received: from vmicros1.altlinux.org (vmicros1.altlinux.org [194.107.17.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 16F7C3F334;
        Sat,  7 May 2022 01:45:14 -0700 (PDT)
Received: from mua.local.altlinux.org (mua.local.altlinux.org [192.168.1.14])
        by vmicros1.altlinux.org (Postfix) with ESMTP id 39CEF72C8FA;
        Sat,  7 May 2022 11:45:14 +0300 (MSK)
Received: by mua.local.altlinux.org (Postfix, from userid 508)
        id 262197CE87A; Sat,  7 May 2022 11:45:14 +0300 (MSK)
Date:   Sat, 7 May 2022 11:45:14 +0300
From:   "Dmitry V. Levin" <ldv@altlinux.org>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Gleb Fotengauer-Malinovskiy <glebfm@altlinux.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Kalle Valo <kvalo@kernel.org>, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2] rfkill: uapi: fix RFKILL_IOCTL_MAX_SIZE ioctl request
 definition
Message-ID: <20220507084514.GA5026@altlinux.org>
References: <20220506171534.99509-1-glebfm@altlinux.org>
 <20220506172454.120319-1-glebfm@altlinux.org>
 <YnYaVeCJA1VQuYie@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YnYaVeCJA1VQuYie@kroah.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, May 07, 2022 at 09:05:57AM +0200, Greg KH wrote:
> On Fri, May 06, 2022 at 05:24:54PM +0000, Gleb Fotengauer-Malinovskiy wrote:
> > Fixes: 54f586a91532 ("rfkill: make new event layout opt-in")
> > Cc: stable@vger.kernel.org # 5.11+
> > Signed-off-by: Gleb Fotengauer-Malinovskiy <glebfm@altlinux.org>
> > ---
> 
> No changelog text at all?  I know I don't take patches like that, maybe
> other subsystem maintainers are more lax?
> 
> Please provide a changelog...

The definition of RFKILL_IOCTL_MAX_SIZE introduced by commit 54f586a91532
is unusable since it is based on RFKILL_IOC_EXT_SIZE which has not been
defined.  Fix that by replacing the undefined constant with the constant
which is intended to be used in this definition.

Signed-off-by: Dmitry V. Levin <ldv@altlinux.org>


-- 
ldv
