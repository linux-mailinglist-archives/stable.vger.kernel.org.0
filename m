Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CAD08A5299
	for <lists+stable@lfdr.de>; Mon,  2 Sep 2019 11:16:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730981AbfIBJQG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Sep 2019 05:16:06 -0400
Received: from sonic308-1.consmr.mail.bf2.yahoo.com ([74.6.130.40]:45009 "EHLO
        sonic308-1.consmr.mail.bf2.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730373AbfIBJQG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Sep 2019 05:16:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1567415765; bh=tPdyM4f7Tq8kspt5syr9wxbiHLUxanV8lkCr2Pkkkas=; h=Date:From:Reply-To:Subject:From:Subject; b=K6HEFBWt+UlpMXSgAPjmVdWFUR+vjj/CXDuQnQNVkMiZm9E4qnHZARcR6ocjLj5CFM6GPdXX5iPwZbp0ItjuGgBcriRYeiUesBBKYLlis6MaT6Z6crfXmcQlD/lD3BEbTZVFgXKJ9yf1nIy8xnetQZ7loxI88RhzitigpOAhxIZYvczteVf6EwzKGJm9TBgMWhD3o/VHk5gMo2UgQpjKH1Ua3d4tsBS5owloXQy53naIa8YFjsSmYFgSWEP/ovyYaE9J03HaE7fLujDhFHdH7oGv5ysSB3LH9IYDWIdgkmrMnWERleuiOfVOeqDrXQRf5yruiCmWI8EW9wnkxu6k7g==
X-YMail-OSG: BvqQhCEVM1kqptjWLCl2oej9c_YR1DKFBa58M31xDMDX8OSxzXp3eMqxlq3iMss
 PJGYyv0rFIolKS2vv8KVOG1lml68O2eb7x7E46h48HVXdrJtk7l7MdAEeTZXncCSyCmaAZR_CgKF
 BIWMHI7L__vzzY4oRUyf82nO84r8JKtGaqptXA6e5EUZmdCcuoLvU2HYG6GfttJLW7qrXqnGo3WV
 EDts5IGDTgGb75Y9NcNrR0frNWZihYdBoAwOFBjhuK6PxHCEG1I6Unxuw5wieAS51LH2jNV6kOil
 o_B1LpakK3MCcoyoecVISZi6RUG4DVKOWMgAkK9Q33vCAxX_YsVT.FJAO7iMkctlnv8qddDe1B4B
 UIDx9i_etHQWnDlhP6Xj_swJzMBSm2GXUTR90I3AgTwv7gLiJmsV.9tE3.sNKJnjGSzsCTZYbMNC
 fGwxJl720I0cc0w9enpdLkhav72B.ng4c_m.t42XAvDlXEkrqqtHKcXchgScaq32AzRP1lppVlbY
 yIzS0lbeb_BatnJHMbYJr6KZ80OxVVjCXkZPccYASSf20eVXfaHAh85C39nGsUDBZCKi6qDYnKyo
 Fln57GO1epGjfGfYTUFHdKyF_ImRy4gls06f7yVmUTpgVp1ZDTAYTOxgRyh9scHhQ8LAX7A3.C_Z
 rvM8Dk3LzZIdVSANhBjBRIXVlq7hKLGwkolBKVrucwDf0VMf9V6a.UPQVmscF9TDI9n0LW0g7_9J
 CHxSA2EmiNB4od5nA40fV75mj1vI0GrUNnQ_PU1bmCdnUIhBrSDe_K4bvCkDrEhE2zxOHEMQPt_j
 pmJuud0IrsbsDKbBE8MFh8.Yfx40oaVKu.SDHaDaeJrtKZHCQGCApsM_Hg6MQ7mSay1QIWqaYCq.
 QlI0S8OIVgl23xOTAE_AM4jHta7BFGPpMUOwUpCucxbd9wEHGye0Y6XJwHH3TLs_ovjbo3ti4wBy
 VGqklwyV58Q9gx.QdTgdK5TCYyFpN99rIa202dACRVdfi8jRsfNUcgDlyd5R7oNJMvdWFKAA1dCs
 A7LOeg3S_Kn98AH60JNevjkWx92wimcKE8tFkBlWI1WyVZtcfOgnMVFXzN_VQFAw0srIPfgMDdHp
 FFIVHqnCFzx_UO7PyyRa781ykRZzXLhzqd7PF2z8Kt0YaD4suwWk8badpQy7P8WUUAsNBIWL3FfN
 16nlvu5DpwR3k_jv69.sV9MuhmiEwuIb0.jb0cbOaWu7xOQWn4F5rUnUvtxKg76MNCtISUNYYeNG
 foclkE4lIo0o-
Received: from sonic.gate.mail.ne1.yahoo.com by sonic308.consmr.mail.bf2.yahoo.com with HTTP; Mon, 2 Sep 2019 09:16:05 +0000
Date:   Mon, 2 Sep 2019 09:16:02 +0000 (UTC)
From:   Aisha Gaddafi <aishag00uu@gmail.com>
Reply-To: gaisha983@gmail.com
Message-ID: <51127364.734026.1567415762966@mail.yahoo.com>
Subject: Dear Friend,
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
To:     unlisted-recipients:; (no To-header on input)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Dear Friend,

I came across your e-mail contact prior a private search while in need of 
your assistance. My name is Aisha  Gaddafi a single Mother and a Widow with 
three Children. I am the only biological Daughter of late Libyan President 
(Late Colonel Muammar Gaddafi).

I have investment funds worth Twenty Seven Million Five Hundred Thousand 
United State Dollar ($27.500.000.00 ) and i need a trusted investment 
Manager/Partner because of my current refugee status, however, I am 
interested in you for investment project assistance in your country, may be 
from there, we can build business relationship in the nearest future.

I am willing to negotiate investment/business profit sharing ratio with you 
base on the future investment earning profits.

If you are willing to handle this project on my behalf kindly reply urgent 
to enable me provide you more information about the investment funds.

Your Urgent Reply Will Be Appreciated.

Best Regards
Mrs Aisha Gaddafi
(gaisha983@gmail.com)
