Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94C3D572EAA
	for <lists+stable@lfdr.de>; Wed, 13 Jul 2022 09:03:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234480AbiGMHDp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Jul 2022 03:03:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234495AbiGMHDm (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Jul 2022 03:03:42 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 222E319022;
        Wed, 13 Jul 2022 00:03:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=n7mQQpkSKyBeUuYBLyboh7IsO0uahzQ+El0fPXZP7kw=;
        t=1657695821; x=1658905421; b=hGarN/jfELl75Cyj8v9aaYvKezIHORvfT0kxx2qvArW200S
        yyOBjQ5pchcQB2863C52jzAsF5Wdf8IDO/4TakWdssBws/sYNmO7sxV92eG4u8JNv0duBT+4icIqV
        XWj+8KlX3LU2CvUCU9kB07nRKRzW8647uBOC6Nl0NEa9a4uiwRxjrIdjH9yQibVmC63/pC//HcMs7
        //EQu7iuiptEKgbIHHL0lqnmc7fsGA5YSaVJqQFBqk0raPpdCE9K4LYX+X9LsY9f4T7XOK5+khQWw
        7mHrP4wVP30RDRQhRrjqCTvdk7tY1OP8xflbmohaskJ5FpfdJ3B1+AxB3DMM3EcQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.95)
        (envelope-from <johannes@sipsolutions.net>)
        id 1oBWPD-00Eavy-S1;
        Wed, 13 Jul 2022 09:03:31 +0200
Message-ID: <9a028efb77ae662fe8eabcf2ffb5a64214f07418.camel@sipsolutions.net>
Subject: Re: [PATCH] um: seed rng using host OS rng
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Anton Ivanov <anton.ivanov@cambridgegreys.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        linux-um@lists.infradead.org, linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org
Date:   Wed, 13 Jul 2022 09:03:31 +0200
In-Reply-To: <d20a629c-8c15-ca8a-c34a-c5c084dbee03@cambridgegreys.com>
References: <20220712232738.77737-1-Jason@zx2c4.com>
         <d20a629c-8c15-ca8a-c34a-c5c084dbee03@cambridgegreys.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.3 (3.44.3-1.fc36) 
MIME-Version: 1.0
X-malware-bazaar: not-scanned
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 2022-07-13 at 07:58 +0100, Anton Ivanov wrote:
>=20
> IIRC UML RNG device reads directly from host.

Yes, but that's a /dev/hwrng device, so you still need some userspace to
feed entropy from that into /dev/random.

> If you are using UMLs own /dev/random you are effectively using the host=
=20
> one.

> So unless I am mistaken, you need extra randomness only if you do not=20
> have UMLs /dev/random compiled in.

No, neither of those is true.

johannes


