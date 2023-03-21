Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 023AD6C3695
	for <lists+stable@lfdr.de>; Tue, 21 Mar 2023 17:09:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229513AbjCUQJA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Mar 2023 12:09:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229902AbjCUQI6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Mar 2023 12:08:58 -0400
Received: from mail.antaris-organics.com (mail.antaris-organics.com [91.227.220.155])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 159E918A83;
        Tue, 21 Mar 2023 09:08:54 -0700 (PDT)
Date:   Tue, 21 Mar 2023 17:08:52 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=mareichelt.com;
        s=202107; t=1679414933;
        bh=Rg076tNuadc80cXN93OEz1lq1Mce0FmGXBkzer80yC8=;
        h=Date:From:To:Subject:References:In-Reply-To:From;
        b=4lI+HbX5SO0kx1Ex/o3dkJMxA3UzIkiJqAtO3uZ4LXbOzZhPxeioxWvZuQBE0veoZ
         x3m/PCmQe5cGgSJg9syMJGIz3u2fDidOXpVt/N4BfcjRr2n1Bmo3aFx5yZ5SI4rn6q
         +iIRduJmelzJDX9F9xGEPItG/mEiq3dfx9YquFsLgJRE1tO2be1XzR0BeosyRHA2my
         ystn+73QkY3wAouoWnRSknpRF/52+4PbmSiJlYqf/Ettn0jXv0TDI2JId3W8Ukg7qc
         r6PE+bMZFTGaUACsKwQaEsTakqUfcVSR/oWJgwcdnCGVzGm07/q3msrf3SRPFTB45d
         mCMQkJAZOxmEg==
From:   Markus Reichelt <lkt+2023@mareichelt.com>
To:     stable@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6.2 000/213] 6.2.8-rc2 review
Message-ID: <20230321160852.GB2458@pc21.mareichelt.com>
Mail-Followup-To: stable@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20230321080604.493429263@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230321080604.493429263@linuxfoundation.org>
Organization: still stuck in reorganization mode
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

* Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> This is the start of the stable review cycle for the 6.2.8 release.
> There are 213 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 23 Mar 2023 08:05:23 +0000.
> Anything received after that time might be too late.

Hi Greg

6.2.8-rc2

compiles, boots and runs here on x86_64
(AMD Ryzen 5 PRO 4650G, Slackware64-15.0)

Tested-by: Markus Reichelt <lkt+2023@mareichelt.com>
