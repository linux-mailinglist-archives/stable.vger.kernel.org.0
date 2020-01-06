Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E720713139D
	for <lists+stable@lfdr.de>; Mon,  6 Jan 2020 15:30:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726437AbgAFOa5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Jan 2020 09:30:57 -0500
Received: from sonic302-2.consmr.mail.bf2.yahoo.com ([74.6.135.41]:35774 "EHLO
        sonic302-2.consmr.mail.bf2.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726307AbgAFOa4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Jan 2020 09:30:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1578321055; bh=E+ks7AydzaUb4ISZTuxin7s0E6gVmk5020fTLYVYB5E=; h=Date:From:Reply-To:Subject:References:From:Subject; b=nyjENOhi8UxyK2iUwuqlEF6LtAUM5An2m/wgNi8F5Utdphgdv9RD3PzxbswPixsg0uFWlZlpr87RijiaaVQbz/VEt/pXb9pLu+xKPCLhWQGaBQeSf7K6+0vlg+mjZwWuXROSZK+L2ygrtl8ZxvdT6xL19Pial0RQ0w4vuL96M4rAU47QvS2I89R2toSUlIFW4rmNHkWBSGKTpP86pdFCYoddsC+N3BFzeklP6ru+2iLOdHBgmdrPST2jyVEVSkYYBHPZJxwgZjYJSCE0jGa0JpuSyvU25lvdwjJAcDSt81Y9MfLLCkgj5BkQTeZ//H56ds3kj3kLUxKUlUljVznZBA==
X-YMail-OSG: P7sK0XQVM1mIGG_1pTO8voo00VnqlzzBlkwzCAJgj1Sq.U.txdpKyhzQJPNMqN7
 GXrPwlE4Hviyq4dDZjmISkaz_J0g_Jhtd54WVWWL5zklKRNdUqKBI72ZzAUzlstd5yPAbwkxbDww
 Igo6O3AOE9uZ4TxTFBQ3r.t32g_ydOBAdgTBh5mgSINEWdZkSNckTWLcKyECf1pa0HJnSrV.YZMH
 AA.9_SlmGSZpI98Ob5TVv8RSJfqXxJPM_YQuP.4PWR5UTWVgu9rEmwD1lPBa16h9XEC_9aDCMVeQ
 XZAxO.CwgeV5rBXZuesMkMZt0A5GXmPZnOEGgEu5PF2k2oH_kVoz4_812jagKZtmS_nZS8i01POA
 e5kGBZfGEjooR5PrZ.XFEKEDk.W8kULzXV8yR8rXo2tRBCoYD6_Zn7nOnUXmgLY5Ik8ht290d4mO
 6P2XyO8CZB9Ttf9kqGaCtIEC_rHclKrx0HIm.r8ZkVcyjaeaql0rR53cl.loW6TKfLBICiIy3KBD
 Sb8yEjV2avRHeve4YSNi072A1rMJOFQqnEZejj4LQlS46tULdWijhCau58ULnW9lcdak19mFe6Sa
 zJ9sS107qyOt6Kl9ZFv03tVIRIL0DttlxvpMR6oBZUkh9hqR3w8.v57c4mu5uM2cBgzjafLuRluQ
 ctPcrxalDcEzaq93Mjr5XeLVcd2DnQaeXcmHu4lCqausys6vDGLqJhELkpX530tTc4j5kcXNeHTz
 ApDdtgJDBX94hmR7jMd13wdweeIKu_UIDev4.PSY6zwpPfWdRigBgk_at.Ka3QQMA_aMCK10g4dm
 LEp.QhtYxVFCHYpmLjhPQHoYEYIMSWpfiq.qjxbhgXTflWDxHb_ZM3hfYt7nvXfg_XZyq5kb6HyJ
 r7vrkPvXCzFZ9wq8q_1kJNipKCLT6hdktnVyv8DQRUSdJb7jzJc5Vy5F08C4o_CUe7OXGiB8Q7UL
 eJBClFsvVrefogpzuEr8Zx0TmTxqYSdquzlkEOIeDhXNJ2w1U6fuNAV5QL_nWMf8IWKLmPQgzke3
 mYovTHefu33jP6xSUTwkPwLZFhCKyMQBPThvuw2wsaJw_Rk8r6yJyMEqVDxFOkXJae_dUpAUlgkW
 AkZ93yf.XwwRfQnRwHZEFMyS9UR3oUHStaLTAc4UTKooWrb8wIZXDoQRLxo1hHzqDIzKB1.rdET8
 bdgmToCbbhl96KxmxdB3IofI4zPK0UrXWMZrraiUh3QtRXWOQsvxAGrwLRYzzq_t_zo6uGsy_VX7
 CY622UMSYnjHlsk1_Fy6maEE5BHzDsE9IivQieNqqj5FPZEoCvqIw6MpuBJFPG6F9p.GtJFIUjfZ
 1fDJ9m_gHIofI6SJaZQ8akJCK7NSr
Received: from sonic.gate.mail.ne1.yahoo.com by sonic302.consmr.mail.bf2.yahoo.com with HTTP; Mon, 6 Jan 2020 14:30:55 +0000
Date:   Mon, 6 Jan 2020 14:30:52 +0000 (UTC)
From:   Aisha Gaddafi <gaisha983@gmail.com>
Reply-To: gaddafia504@gmail.com
Message-ID: <1969962164.4791923.1578321052845@mail.yahoo.com>
Subject: Dear Friend,
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
References: <1969962164.4791923.1578321052845.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.14873 YMailNodin Mozilla/5.0 (Windows NT 6.1; rv:71.0) Gecko/20100101 Firefox/71.0
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
(gaddafia504@gmail.com)
