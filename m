Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC229413C8E
	for <lists+stable@lfdr.de>; Tue, 21 Sep 2021 23:34:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235422AbhIUVg1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Sep 2021 17:36:27 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:46774 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235437AbhIUVg0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Sep 2021 17:36:26 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 0FF651C0B76; Tue, 21 Sep 2021 23:34:57 +0200 (CEST)
Date:   Tue, 21 Sep 2021 23:34:56 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>,
        Rob Herring <robh@kernel.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Srinath Mannam <srinath.mannam@broadcom.com>,
        Roman Bacik <roman.bacik@broadcom.com>,
        Bharat Gooty <bharat.gooty@broadcom.com>,
        Abhishek Shah <abhishek.shah@broadcom.com>,
        Jitendra Bhivare <jitendra.bhivare@broadcom.com>,
        Ray Jui <ray.jui@broadcom.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        BCM Kernel Feedback <bcm-kernel-feedback-list@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 082/122] PCI: of: Dont fail
 devm_pci_alloc_host_bridge() on missing ranges
Message-ID: <20210921213456.GB29170@duo.ucw.cz>
References: <20210920163915.757887582@linuxfoundation.org>
 <20210920163918.481485606@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="kORqDWCi7qDJ0mEj"
Content-Disposition: inline
In-Reply-To: <20210920163918.481485606@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--kORqDWCi7qDJ0mEj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

There is something is wrong with the Subject. Commit says "Don't", but
subject says "Dont". It confused me for a while.

Best regards,
								Pavel
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--kORqDWCi7qDJ0mEj
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCYUpQAAAKCRAw5/Bqldv6
8st4AKCYqFPCJlIifDruoAmYlHHPxIvtwwCeN6G0uKIF5/TFsDE0zAErdu7eFmo=
=CMrU
-----END PGP SIGNATURE-----

--kORqDWCi7qDJ0mEj--
