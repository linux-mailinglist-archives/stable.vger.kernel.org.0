Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBB646C354F
	for <lists+stable@lfdr.de>; Tue, 21 Mar 2023 16:15:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230387AbjCUPPw convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Tue, 21 Mar 2023 11:15:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229783AbjCUPPv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Mar 2023 11:15:51 -0400
Received: from outpost1.zedat.fu-berlin.de (outpost1.zedat.fu-berlin.de [130.133.4.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC9C446B4;
        Tue, 21 Mar 2023 08:15:49 -0700 (PDT)
Received: from inpost2.zedat.fu-berlin.de ([130.133.4.69])
          by outpost.zedat.fu-berlin.de (Exim 4.95)
          with esmtps (TLS1.3)
          tls TLS_AES_256_GCM_SHA384
          (envelope-from <glaubitz@zedat.fu-berlin.de>)
          id 1pediD-000du9-EN; Tue, 21 Mar 2023 16:15:45 +0100
Received: from p57bd9952.dip0.t-ipconnect.de ([87.189.153.82] helo=[192.168.178.81])
          by inpost2.zedat.fu-berlin.de (Exim 4.95)
          with esmtpsa (TLS1.3)
          tls TLS_AES_256_GCM_SHA384
          (envelope-from <glaubitz@physik.fu-berlin.de>)
          id 1pediD-002Jrt-7B; Tue, 21 Mar 2023 16:15:45 +0100
Message-ID: <3a00d2b54f990e2fa18db722a81bea78402668c9.camel@physik.fu-berlin.de>
Subject: Re: [PATCH 6/7 v5] sh: fix Kconfig entry for NUMA => SMP
From:   John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
To:     Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     Randy Dunlap <rdunlap@infradead.org>, linux-kernel@vger.kernel.org,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Rich Felker <dalias@libc.org>, linux-sh@vger.kernel.org,
        stable@vger.kernel.org
Date:   Tue, 21 Mar 2023 16:15:44 +0100
In-Reply-To: <CAMuHMdV-hAcf+uaWvLdXef6jOUHWV04u0FS2dGHxtJArG6c_Wg@mail.gmail.com>
References: <20230320231310.28841-1-rdunlap@infradead.org>
         <CAMuHMdXnbRvCjtgpbMnUVoRbHSk407t7Sr4XPpoiaE7M1h+4Ng@mail.gmail.com>
         <ad2234ad155d51c142e59adcf2981bce23d69aa4.camel@physik.fu-berlin.de>
         <CAMuHMdW-oxpoHubUJUpsjG9aXtQ3MMwAopN-hS+Mf0gN1udhig@mail.gmail.com>
         <fa8b4f3ca8f3d9dc0487399962bcc6ef75ebd6b0.camel@physik.fu-berlin.de>
         <CAMuHMdV-hAcf+uaWvLdXef6jOUHWV04u0FS2dGHxtJArG6c_Wg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
User-Agent: Evolution 3.46.4 
MIME-Version: 1.0
X-Original-Sender: glaubitz@physik.fu-berlin.de
X-Originating-IP: 87.189.153.82
X-ZEDAT-Hint: PO
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Geert!

On Tue, 2023-03-21 at 09:47 +0100, Geert Uytterhoeven wrote:
> > Yeah, this explains it then. Your new patch is definitely the better approach
> > and I would prefer it over Randy's suggested change. Let's see what the mm
> > maintainers have to say.
> 
> I'm sure the missed condition was just an oversight, so I expect no
> objections.

And you were right, of course. We can drop Randy's patch then, but I'll pick up
all the other patches tomorrow when I prepare my for-next tree for 6.4.

Adrian

-- 
 .''`.  John Paul Adrian Glaubitz
: :' :  Debian Developer
`. `'   Physicist
  `-    GPG: 62FF 8A75 84E0 2956 9546  0006 7426 3B37 F5B5 F913
