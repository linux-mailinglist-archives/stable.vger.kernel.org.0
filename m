Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B16706B106D
	for <lists+stable@lfdr.de>; Wed,  8 Mar 2023 18:50:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229840AbjCHRuu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Mar 2023 12:50:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229845AbjCHRul (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Mar 2023 12:50:41 -0500
Received: from eggs.gnu.org (eggs.gnu.org [IPv6:2001:470:142:3::10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F39C08F716
        for <stable@vger.kernel.org>; Wed,  8 Mar 2023 09:50:38 -0800 (PST)
Received: from fencepost.gnu.org ([2001:470:142:3::e])
        by eggs.gnu.org with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.90_1)
        (envelope-from <psmith@gnu.org>)
        id 1pZxvv-0001xC-P6; Wed, 08 Mar 2023 12:50:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=gnu.org;
        s=fencepost-gnu-org; h=MIME-Version:References:In-Reply-To:Date:To:From:
        Subject; bh=YPw9nRlqCe+8PYPuehwp84jnOHks66M9SxVq4XA3Tb8=; b=DSfm+GMSqRBQJ9UHe
        HIVa4JCNMhhCtN2c7y1aM7BY2GtV1y9GY+JSPPOuflDXgy2QJ7f5Ok73nbiCT2STxujF2o6OZ2d1W
        nyFRJM46zImjC6/5W7JVN0VYlbGX3EROr3ekPwjBY/lTCKEvDtpiLXqoI9rZXyQjcXufq9uHBM/+h
        w1TJCyUEghb3ifTKMu0YwmRhd4NWpXhb/YS2F0YlKmWndb575h9YJ3YEFDN5GhwX/SOyN2B7hiiPE
        NsMG/ORLhmOO12+G+UVRcpC6WLhW5zv7E52G6H/fxWWptrMQpzUVTANdQyjC0tCkDUZ1t/gvtYfBa
        Q9NSovSxgojTpXUFw==;
Received: from [160.231.0.90] (helo=llin-psh13-dsa.dsone.3ds.com)
        by fencepost.gnu.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.90_1)
        (envelope-from <psmith@gnu.org>)
        id 1pZxvq-0004pJ-FR; Wed, 08 Mar 2023 12:50:33 -0500
Message-ID: <da9742e35f9fd795453b41643675df00441781f0.camel@gnu.org>
Subject: Re: No progress output when make 4.4.1 builds Linux 4.19 and earlier
From:   Paul Smith <psmith@gnu.org>
Reply-To: psmith@gnu.org
To:     David Laight <David.Laight@ACULAB.COM>,
        Greg KH <gregkh@linuxfoundation.org>
Cc:     Eric Biggers <ebiggers@kernel.org>,
        "bug-make@gnu.org" <bug-make@gnu.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Date:   Wed, 08 Mar 2023 12:50:28 -0500
In-Reply-To: <72676b579d6f48288044a512fd51d0af@AcuMS.aculab.com>
References: <ZAgnmbYtGa80L731@sol.localdomain> <ZAgogdFlu69QlYwu@kroah.com>
         <CAG+Z0CuAQsq-1DNaX0_qHnqSBt1YrUBbBaypxgwT0USFyOkk4g@mail.gmail.com>
         <4e731dfbe197f5c0a6c1093aee503b7f4d76cc1a.camel@gnu.org>
         <72676b579d6f48288044a512fd51d0af@AcuMS.aculab.com>
Organization: GNU's Not UNIX!
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (by Flathub.org) 
MIME-Version: 1.0
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 2023-03-08 at 15:53 +0000, David Laight wrote:
> Adding a $(filter-out --%,...) should help with old makes:

Yes that's what is there.  See the link to the commit I posted.

I just couldn't remember why it was necessary to treat things
differently between different versions.  Dmitry reminded me.
