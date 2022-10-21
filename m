Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36512606C7A
	for <lists+stable@lfdr.de>; Fri, 21 Oct 2022 02:29:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229866AbiJUA3m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Oct 2022 20:29:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229867AbiJUA3j (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Oct 2022 20:29:39 -0400
Received: from relay1-d.mail.gandi.net (relay1-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::221])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 009212E6A6
        for <stable@vger.kernel.org>; Thu, 20 Oct 2022 17:29:35 -0700 (PDT)
Received: (Authenticated sender: didi.debian@cknow.org)
        by mail.gandi.net (Postfix) with ESMTPSA id E583E240004;
        Fri, 21 Oct 2022 00:29:32 +0000 (UTC)
From:   Diederik de Haas <didi.debian@cknow.org>
To:     stable@vger.kernel.org, gregkh@linuxfoundation.org,
        Alex Deucher <alexander.deucher@amd.com>
Cc:     Alex Deucher <alexander.deucher@amd.com>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        Salvatore Bonaccorso <carnil@debian.org>
Subject: Re: [PATCH 1/2] Revert "drm/amdgpu: move nbio sdma_doorbell_range() into sdma code for vega"
Date:   Fri, 21 Oct 2022 02:29:22 +0200
Message-ID: <2651645.mvXUDI8C0e@bagend>
Organization: Connecting Knowledge
In-Reply-To: <20221020153857.565160-1-alexander.deucher@amd.com>
References: <20221020153857.565160-1-alexander.deucher@amd.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart12077226.O9o76ZdvQC"; micalg="pgp-sha256"; protocol="application/pgp-signature"
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--nextPart12077226.O9o76ZdvQC
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"; protected-headers="v1"
From: Diederik de Haas <didi.debian@cknow.org>
Date: Fri, 21 Oct 2022 02:29:22 +0200
Message-ID: <2651645.mvXUDI8C0e@bagend>
Organization: Connecting Knowledge
In-Reply-To: <20221020153857.565160-1-alexander.deucher@amd.com>
References: <20221020153857.565160-1-alexander.deucher@amd.com>
MIME-Version: 1.0

On Thursday, 20 October 2022 17:38:56 CEST Alex Deucher wrote:
> This reverts commit 9f55f36f749a7608eeef57d7d72991a9bd557341.
> 
> This patch was backported incorrectly when Sasha backported it and
> the patch that caused the regression that this patch set fixed
> was reverted in commit 412b844143e3 ("Revert "PCI/portdrv: Don't disable AER
> reporting in get_port_device_capability()""). This isn't necessary and
> causes a regression so drop it.
> 
> Bug: https://gitlab.freedesktop.org/drm/amd/-/issues/2216
> Cc: Shuah Khan <skhan@linuxfoundation.org>
> Cc: Sasha Levin <sashal@kernel.org>
> Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
> Cc: <stable@vger.kernel.org>    # 5.10
> ---

I build a kernel with these 2 patches reverted and can confirm that that fixes 
the issue on my machine with a Radeon RX Vega 64 GPU. 
# lspci -nn | grep VGA
0b:00.0 VGA compatible controller [0300]: Advanced Micro Devices, Inc. [AMD/
ATI] Vega 10 XL/XT [Radeon RX Vega 56/64] [1002:687f] (rev c1)

So feel free to add

Tested-By: Diederik de Haas <didi.debian@cknow.org>

--nextPart12077226.O9o76ZdvQC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQT1sUPBYsyGmi4usy/XblvOeH7bbgUCY1Hn4gAKCRDXblvOeH7b
brmdAQCpvWWlrAt/SH7IfiyA0vMBoYauDzrq/gZEkhhGzQUHqgEA74vs4JokVrAg
gL0eGQSB7OHtFzX+Phxae8SyhLahXQo=
=Ewlb
-----END PGP SIGNATURE-----

--nextPart12077226.O9o76ZdvQC--



