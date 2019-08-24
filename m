Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A2A929BC30
	for <lists+stable@lfdr.de>; Sat, 24 Aug 2019 08:16:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725948AbfHXGPK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 24 Aug 2019 02:15:10 -0400
Received: from sonic305-1.consmr.mail.bf2.yahoo.com ([74.6.133.40]:37152 "EHLO
        sonic305-1.consmr.mail.bf2.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725777AbfHXGPJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 24 Aug 2019 02:15:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1566627308; bh=tPdyM4f7Tq8kspt5syr9wxbiHLUxanV8lkCr2Pkkkas=; h=Date:From:Reply-To:Subject:From:Subject; b=l7Za5E5lW34vzcjtdj51IcHd3Uaj86fa/qlbf8n3Br3/BE9WpSKCk5HON5b9c50Gkh+MSlhSgykMxLrU7YvNPiYZB/uGKbSM3tRTy7q+x43qFUIQ+YeSEF9rJv4V84sNv9TMpRukR7eAvvMiW0d2vcGcCxYJVMDX/0PyFC7//NPFqVeAUnSVxMzfO5PDsbyZhlb5Mfc39OeSNV1sE5ifj5MShXAG1/hr0NXhgrf3tGy+7jTWGOnhD0/MiyckzMx8TE1GKWu6bkawdgpusYfdEK36it5i5LGVLep7/HOnPfE3/B9bW+Axisd/wS+d+yagXnOkM+amkKvzlAggogaErw==
X-YMail-OSG: zfzuKGgVM1kZvdmEG_PVvQyBS2Alw30Mi2j0Duu7LCpXHyz2M1Z.CU3rbMQEAvO
 3aV2Ivn3iMINjnuENBPL.v7lWQ7.Hn7wCZs5q8jMZKK6xKdEb3YdCsYuA370KClpe6uLK3RYgHVj
 c2TdafdUzTHWfP8TAHSmAClKd9hi1FNqFd0pNCKK2MuLYVU_zpe6ZVsHSuk668HsSvnooYugHwiI
 7ve8zTgBNYm1gWu1TX6ndL76zmPmUA_bQkeesAahVy4_BaBaJznIOESxd7hgbEpYcPj2BI85Ds_Q
 LiknpqY0GUsx1tFxOoIaX1uEfQk6SjloR3GRv.4SbD8KeWBUYfzvFNJZYnDMfMPw00fBkdZGWM4z
 7i831meea1O9DChg3ncn2nVdH8EvYsIZvXn5eyvwfkO8HvNlGErIB4P_jTSM5nEx2i1FT1lFiPh7
 PMWa5C8ftQrU_mwKxtyilmGa5yJnO1Y8Yj4e7VCIOq94wLyLw2bE7a4zBkhcjiyrJZU6SThruvyA
 eLrIyj2TM_6guzZKx9.ZxzBBiQjcR5YSbAmRk61S_8NlTuA3z9sIHjeLjRCUDCL6f7Ngv9m4vPh0
 eZolt5aa_Sp9qEby871P0nULx3r1cOtxt41KPjSEmrOuzmWk6qTp92lut9c0d.lnHKLl.KkDrq2J
 AVN2FgvGEiYl.QAyP8sdJdxzL6BHNdNhHlHdfQCiaoO.OablXiio3XNkg3Fppy71PlLO9suaQbMw
 s_wM3ny_cOFIQHdaundk_Je2hbRtHI.TWxAilhABQhuxHwXspUhZ_GoPVSkLxHRya8FQ7Es3L4Iu
 ehgNLFKDSGcOeP6Bgc0mykPgxq.QGqbZrjngyyIRpGVgNoHcvzaBDifhIaI97R3vcI9DLHtFYxBO
 2XcNyRByYa7KlWRZ.rH0xRuuaSPgMqiPsyg354.0HcKGnr.vtMROAsroqriL0JE31h0bWSUFHgcP
 GCCwqODvfWctA98CmKHhn_NV7NHB.JNqn34f1tem6vehWHr.20HH6TnXQykPoZQZh_A_DvuWo37B
 JLQJC9Wbs.qqcgcRcGO52c0sLgdYaxqv0pORLv9Au0fHrt7KVeXSkePqJsc5TpbHbJTfCev_Ffo.
 TxqMRHPs2lmo6k3Hc.RZvk6uoP.vQl1jUJK1u.zo44PE3MlW5fYEZm.HuRgVc72NMHYMRAl3NTYv
 MhKIK68pyKij.egv6o7Bn90E7Mro.RGtiMaA3TghginYpsBD9RTB22DUfFZ9CM7bBdfaDo0rOAJZ
 IK9w-
Received: from sonic.gate.mail.ne1.yahoo.com by sonic305.consmr.mail.bf2.yahoo.com with HTTP; Sat, 24 Aug 2019 06:15:08 +0000
Date:   Sat, 24 Aug 2019 06:15:04 +0000 (UTC)
From:   Aisha Gaddafi <agaddafibb@gmail.com>
Reply-To: gaisha983@gmail.com
Message-ID: <1069178085.1071791.1566627304295@mail.yahoo.com>
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
