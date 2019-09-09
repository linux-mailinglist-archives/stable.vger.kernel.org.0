Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6850AAD5CE
	for <lists+stable@lfdr.de>; Mon,  9 Sep 2019 11:35:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728390AbfIIJfe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Sep 2019 05:35:34 -0400
Received: from heliosphere.sirena.org.uk ([172.104.155.198]:58830 "EHLO
        heliosphere.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728313AbfIIJfe (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Sep 2019 05:35:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sirena.org.uk; s=20170815-heliosphere; h=In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=RtSMw7LYI0eRDUtlq7qfyGVEIrksQWu0YB0DV1ta/d4=; b=HbRyn1jg+EF/Yur3Fl3HRguL3
        6veVfjDcccwm+LR6G1qecksYT24lMhDU/JTMjTC4+R76PCEYp8LiLE6HgU1HPfy1ZtrHIry8LC2ng
        a+EKmOwYWdWtFPL95aGNtSvP63KWUJKfkQkzDeChebh3bqB2QB4U6RjJtYXVYg9kjDFwE=;
Received: from [148.69.85.38] (helo=fitzroy.sirena.org.uk)
        by heliosphere.sirena.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <broonie@sirena.org.uk>)
        id 1i7G51-0001es-Nd; Mon, 09 Sep 2019 09:35:27 +0000
Received: by fitzroy.sirena.org.uk (Postfix, from userid 1000)
        id 9A98DD02D18; Mon,  9 Sep 2019 10:35:26 +0100 (BST)
Date:   Mon, 9 Sep 2019 10:35:26 +0100
From:   Mark Brown <broonie@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     Ricard Wanderlof <ricard.wanderlof@axis.com>,
        stable@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
        linux-kernel@vger.kernel.org
Subject: Re: revert: ASoC: Fail card instantiation if DAI format setup fails
Message-ID: <20190909093526.GA2036@sirena.org.uk>
References: <20190814021047.14828-1-sashal@kernel.org>
 <20190814021047.14828-40-sashal@kernel.org>
 <20190814092213.GC4640@sirena.co.uk>
 <20190826013515.GG5281@sasha-vm>
 <20190827110014.GD23391@sirena.co.uk>
 <20190828021311.GV5281@sasha-vm>
 <alpine.DEB.2.20.1908280859060.5799@lnxricardw1.se.axis.com>
 <alpine.DEB.2.20.1909061031200.3985@lnxricardw1.se.axis.com>
 <20190906105824.GS23391@sirena.co.uk>
 <20190906183824.GB1528@sasha-vm>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="WIyZ46R2i8wDzkSu"
Content-Disposition: inline
In-Reply-To: <20190906183824.GB1528@sasha-vm>
X-Cookie: Be careful!  UGLY strikes 9 out of 10!
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--WIyZ46R2i8wDzkSu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Sep 06, 2019 at 02:38:24PM -0400, Sasha Levin wrote:

> However, I'd like to say that I don't agree with it. I understand your
> reasoning about keeping the stable trees conservative, but I feel that
> going to the extreme with it will just encourage folks to not upgrade
> between major versions.

This is a case where the change can't possibly make anything work
in itself, it can only break things and help with debugging.  If
people are sitting on stable hopefully they're not still
debugging their systems.  I don't understand why you are pushing
so hard for this, there is very little upside on stable.

> I'd like to think that upgrading major versions should be the same as
> upgrading minor ones (because numbers don't matter here). If that's not
> the case, let's fix it!

Backporting this won't help achieve that aim.

--WIyZ46R2i8wDzkSu
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAl12HN0ACgkQJNaLcl1U
h9Aapwf/SgDF6oiU9JmzPlzW9MsZjxf8dqgRL4pbbK/O/O1qCudJT5WG+X11YLu0
lG6PWiUCflFBMikLLCxDSu5e9V33X10eqFgV/TRT91dnJZQ0JUQnV8M/X+LYYWXF
hNP4InFCZEUm7G/M7IrSgUrvu350qCttPhfd8PfPBnJ9yibbgGopvmULvnTzbCn8
MfPxtzLah0ceaySCYTQ35U9jQvLbqJcGq4+MEhQMTCABC7sKF4dGZ7nqx7l1mEWw
DkEiVuCCtALMp7eZiICCzdXXvyYkf7D8D74VIqTA+PoYEc/eETFITw1LFW7tmPzn
ssh4Js0xumuTSs9QRqNkN6A1cz3ATQ==
=131T
-----END PGP SIGNATURE-----

--WIyZ46R2i8wDzkSu--
