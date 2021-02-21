Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DFB9320DC8
	for <lists+stable@lfdr.de>; Sun, 21 Feb 2021 22:02:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231187AbhBUVAr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 21 Feb 2021 16:00:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:43922 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231184AbhBUVAn (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 21 Feb 2021 16:00:43 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A634864DF2;
        Sun, 21 Feb 2021 20:58:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613941134;
        bh=NaOEgMBD8HLpidD6cPswYheiU10EK0FKnHOHuIzLaGU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=rxZsN7nSfB2u7FcnEXVmCAq9/1WwuRi5JusO6bL0jYVlXy+yjMrLCemYPy5PDCA+M
         VBwnFMk+XFXVnTzZoOmJpMp8xUjHc+vIi4xveWWJ75vrxJ+p8vOTzvLJ+I5aU6uVUT
         RA34xw1MlZ12kStJP1KYB6ZKQw4uT2tte/Rh9QFTTKED15tH3RNaj/Tn22Rk+sCX8D
         2lqfHcg7qJdl7KPRiT+QvfFX/+et+h5bogOjJBFn2RWg2+nj7ANKbR3eFQRB+BZpw1
         wz88we1ytDm7zDBGsQC7s/c36NG9zAGquYmgfvXckj7CyYCPYD5oVTvbJUPgYLS8ls
         P/0WrwFactlRw==
Date:   Sun, 21 Feb 2021 21:58:50 +0100
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Gregory CLEMENT <gregory.clement@bootlin.com>,
        Rui Salvaterra <rsalvaterra@gmail.com>,
        Uwe =?UTF-8?B?S2xlaW5lLUvDtm5pZw==?= <uwe@kleine-koenig.org>,
        linux-arm-kernel@lists.infradead.org, stable@vger.kernel.org
Subject: Re: [PATCH mvebu-dt] ARM: dts: turris-omnia: configure LED[2]/INTn
 pin as interrupt pin
Message-ID: <20210221215850.51a7570f@kernel.org>
In-Reply-To: <YDLH8z9R7EQHFEkU@lunn.ch>
References: <20210220231144.32325-1-kabel@kernel.org>
        <YDLH8z9R7EQHFEkU@lunn.ch>
X-Mailer: Claws Mail 3.17.7 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, 21 Feb 2021 21:52:03 +0100
Andrew Lunn <andrew@lunn.ch> wrote:

> > This patch fixes bug introduced with the commit that added Turris
> > Omnia's DTS (26ca8b52d6e1), but will not apply cleanly because there is
> > commit 8ee4a5f4f40d which changed node name and node compatible
> > property and this commit did not go into stable.
> > 
> > So either commit 8ee4a5f4f40d has also to go into stable before this, or
> > this patch has to be fixed a little in order to apply to 4.14+.  
> 
> Once this has made it into Linus's tree, you can give GregKH a version
> which will apply cleanly to 4.14.  Reference the upstream version so
> they can be linked together.

Thank you, Andrew!
