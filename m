Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7D916B109D
	for <lists+stable@lfdr.de>; Wed,  8 Mar 2023 19:06:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229761AbjCHSGO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Mar 2023 13:06:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229551AbjCHSGN (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Mar 2023 13:06:13 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBF65C859F
        for <stable@vger.kernel.org>; Wed,  8 Mar 2023 10:06:12 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id A225E1FE54;
        Wed,  8 Mar 2023 18:06:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1678298771; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=C98moWz3UmgJ06o9qmv5+4d9M+DqkRdzyUAcN/fugrI=;
        b=Cu8dkwR807LExBdeNsIEqNT6RfWg413EXpIOzqX+Wpndm7jLbRn+pk/Ef9sjzE4P8lHwwh
        H5LDueICCxX2IseO/jkZLQZoRggUkfVexMzAJVrCEtFvfFn4JmTq2wEX3/AVTG/AKB0puc
        misQf5DeIsb+L2Jg54AocVR9qYioPLw=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 603891391B;
        Wed,  8 Mar 2023 18:06:11 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id c/gNFpPOCGQmaAAAMHmgww
        (envelope-from <mwilck@suse.com>); Wed, 08 Mar 2023 18:06:11 +0000
Message-ID: <8579fc77c0de08c17d6d34b4d5dcc9386d69ebba.camel@suse.com>
Subject: Re: Please apply commit 06e472acf964 ("scsi: mpt3sas: Remove usage
 of dma_get_required_mask() API") to stable series
From:   Martin Wilck <mwilck@suse.com>
To:     Salvatore Bonaccorso <carnil@debian.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     stable <stable@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        "Linux regression tracking (Thorsten Leemhuis)" 
        <regressions@leemhuis.info>
Date:   Wed, 08 Mar 2023 19:06:10 +0100
In-Reply-To: <ZAi4k/09acWV0wRZ@eldamar.lan>
References: <ZAMUx8rG8xukulTu@eldamar.lan>
         <yq1356hnzd2.fsf@ca-mkp.ca.oracle.com> <ZAi4k/09acWV0wRZ@eldamar.lan>
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 
MIME-Version: 1.0
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 2023-03-08 at 17:32 +0100, Salvatore Bonaccorso wrote:
> hi Martin, hi Sreekanth,
>=20
> On Mon, Mar 06, 2023 at 08:16:35PM -0500, Martin K. Petersen wrote:
> >=20
> > Hi Salvatore!
> >=20
> > > Sreekanth and Martin is this still on your radar?
> >=20
> > Broadcom will have to provide a suitable fix for the relevant older
> > stable releases. It is the patch author's responsibility to provide
> > backports.
> >=20
> > > as 9df650963bf6 picking as well is not an option.
> >=20
> > Why not?
>=20
> Thanks to Martin Wilck from SUSE to get me understanding the picture.
> The problem is that e0e0747de0ea ("scsi: mpt3sas:
> Fix return value check of dma_get_required_mask()") was backported to
> several series. In mainline though the mis-merge did undo that. So I
> believe the right thing would be to revert first in the stable series
> where it was applied (5.10.y, 5.15.y) the commit e0e0747de0ea ("scsi:
> mpt3sas: Fix return value check of dma_get_required_mask()")=A0 and
> then
> on top of this revert apply the patches:
>=20
> 9df650963bf6 ("scsi: mpt3sas: Don't change DMA mask while
> reallocating pools")
> 1a2dcbdde82e ("scsi: mpt3sas: re-do lost mpt3sas DMA mask fix")
> 06e472acf964 ("scsi: mpt3sas: Remove usage of dma_get_required_mask()
> API")
>=20
> Attached mbox file implements this.
>=20
> Does that looks now good for resolving the regression?
>=20

Yes, this makes sense and it's actually the same thing I did for our
5.14 series. Thanks for re-figuring it out, the matter is really
confusing.

Regards,
Martin

