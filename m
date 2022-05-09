Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9782E51FF3D
	for <lists+stable@lfdr.de>; Mon,  9 May 2022 16:13:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236827AbiEIOP2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 May 2022 10:15:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236764AbiEIOP1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 May 2022 10:15:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDB872ED74;
        Mon,  9 May 2022 07:11:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2E24CB816D5;
        Mon,  9 May 2022 14:11:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92010C385A8;
        Mon,  9 May 2022 14:11:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652105491;
        bh=ZplY4V2E0R22u2cAJ6HxdJLDsFGOtXCw2rNUg77qF+4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=esTrYB+BapYV6UnIlXwtq7sA314up20ZFN4MsaqxLV4jIYYOdNuKNq4sRsd1+rANk
         R8DMLZ46Qa47PaRCI3J5IgwIaJnJ36F9snCxLuS1VMuQAkv9ebAXvxH9CHMUtPOq5G
         Bi6s3wFglnt/EU4mmysntjZmlZZfDRaE38uzl66I=
Date:   Mon, 9 May 2022 16:11:27 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Cc:     herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
        qat-linux@intel.com, Vlad Dronov <vdronov@redhat.com>,
        stable@vger.kernel.org,
        Marco Chiappero <marco.chiappero@intel.com>,
        Adam Guerin <adam.guerin@intel.com>,
        Wojciech Ziemba <wojciech.ziemba@intel.com>
Subject: Re: [PATCH v3 10/10] crypto: qat - re-enable registration of
 algorithms
Message-ID: <YnkhD5YY3thCMkgX@kroah.com>
References: <20220509133417.56043-1-giovanni.cabiddu@intel.com>
 <20220509133417.56043-11-giovanni.cabiddu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220509133417.56043-11-giovanni.cabiddu@intel.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 09, 2022 at 02:34:17PM +0100, Giovanni Cabiddu wrote:
> Re-enable the registration of algorithms after fixes to (1) use
> pre-allocated buffers in the datapath and (2) support the
> CRYPTO_TFM_REQ_MAY_BACKLOG flag.
> 
> This reverts commit 8893d27ffcaf6ec6267038a177cb87bcde4dd3de.

Then why not just have this be a "normal" revert commit?

And why is this ok for stable kernels?  This feels like a new feature
(i.e. the code finally works.)  Why not just have users who want to use
this use a newer kernel?  What bugfix does this resolve in older kernels
(and "the driver did not work" is not really a good reason.)

thanks,

greg k-h
