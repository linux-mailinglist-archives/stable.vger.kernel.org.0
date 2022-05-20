Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E05052EA8E
	for <lists+stable@lfdr.de>; Fri, 20 May 2022 13:14:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344894AbiETLOd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 May 2022 07:14:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241462AbiETLOc (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 May 2022 07:14:32 -0400
Received: from theia.8bytes.org (8bytes.org [81.169.241.247])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE8069E9C7
        for <stable@vger.kernel.org>; Fri, 20 May 2022 04:14:30 -0700 (PDT)
Received: by theia.8bytes.org (Postfix, from userid 1000)
        id E016022A; Fri, 20 May 2022 13:14:28 +0200 (CEST)
Date:   Fri, 20 May 2022 13:14:27 +0200
From:   Joerg Roedel <joro@8bytes.org>
To:     =?iso-8859-1?Q?J=F6rg-Volker?= Peetz <jvpeetz@web.de>
Cc:     SuraveeSuthikulpanit <suravee.suthikulpanit@amd.com>,
        vasant.hegde@amd.com, WillDeacon <will@kernel.org>,
        stable@vger.kernel.org
Subject: Re: Linux 5.17.5
Message-ID: <Yod4E9K8ZFOxso3Z@8bytes.org>
References: <165106510338255@kroah.com>
 <a5c7406e-64b0-7522-fef0-27fec1ac6698@web.de>
 <Ym+oOjFrkdju5H6X@8bytes.org>
 <4bfd2811-69ec-e4ec-2957-7054a075aa50@web.de>
 <YnI2QYZ1GqmORC10@8bytes.org>
 <f731aff4-a20a-26b3-473f-723b65e760ce@web.de>
 <YodtvQJXInHDI3lD@8bytes.org>
 <22b19b34-5cf8-e026-97f8-c66011ee535b@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <22b19b34-5cf8-e026-97f8-c66011ee535b@web.de>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, May 20, 2022 at 12:48:28PM +0200, Jörg-Volker Peetz wrote:
> Yes, I will test it on top of 5.17.9, o.k.?

That would be great, thanks!

> Would you also be interested to get a timing from my computer?

Only if the patch does not fix it for you.

Regards,

	Joerg
