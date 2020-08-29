Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAF6825693A
	for <lists+stable@lfdr.de>; Sat, 29 Aug 2020 19:09:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728422AbgH2RJB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 29 Aug 2020 13:09:01 -0400
Received: from sonic314-13.consmr.mail.bf2.yahoo.com ([74.6.132.123]:45733
        "EHLO sonic314-13.consmr.mail.bf2.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728410AbgH2RJA (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 29 Aug 2020 13:09:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1598720939; bh=fiS559YMj0kiaG+UTAtmBO7yGCSFherXYbZ1I9WCe+8=; h=Date:From:Reply-To:Subject:References:From:Subject; b=H/hNKqfWT/3mAjAcCGt2uRXj6SBneRwW6EdvAcGL10x29AhbVw/kuq/Z5ThFEMVEgubYM+noMo4923k7XWOVVxfnQZeODiDmlSerXZyQ4ASswaZu+zG3HKk+C0UTeUAtbGupGGNlpwULcql+1KwoUR0lxMMXNoZ5UgLjknAXzv2r27Vmjndm9YGFt+l2mPMOMPoux9494fzpPoKANkW/R6KLMDODMaW7Ame4zt0FnqGp0ET0413BmdFCFYFSBiPNsDpZT9n25kPLSK+PPXi1hTK+OZ9Onf5VsIPbTVgx34MH+z+cM1Wt2kYS0FboWzrN9py+ZMGGWwjKFyfE1UMy+g==
X-YMail-OSG: o5sToTkVM1mpgmqbD36Mug_oeMs_T5Zf0q1FNN8xSqWx0xbhjQhWNnB9H6sbhNv
 Nu91CZCqw0m.ZzC3itwC9aC0S5qHz1SHYVnuFESJBunQ3M4ZcD4F.oNyifTvssTwmvrjloMwQnuT
 sb4OVKciaLk.5OjAk7uBf8C_lcBMhm0q.1CO1TBjagnW3yqCNIMsHBvfxznfGVbzHmm95p3LMGmv
 8u8z_MHykLFWieUdFB67pxxXoQIQx7Vm3D2CUSzgobfevvZvRBUThYzOILdFlaDq1InZVqt3qmks
 S46NZAOtHGDNqnv5QwjPWLJQ3NcUIz.SPFo.WxOHKdww5_ZUqyu.EdfMKMt_SDnoWZTCwDgw.RFo
 7B81zw20PynwXIrLW9_wJeI8uS3QYvO8QdK6lbLiEVcqkUZILhTg7VJdDIk4JU8m33ER3rGOvJe8
 JzbkLWF2CLzGzmiuz_4EwnS.198lhqqcVnnhtXCJN_ZqkIE7g8k63tjs1tl2xvv0AHz6MIpqndBx
 CnsiqbstVS1ues3wrY.R1pYNFvSaODKODxGEWZ8fFnnd6WvSHrAzGJrlhBWcr76ElujfuZUMd7di
 HjrAGftW1xfetOsr_deKxVEcGK9eivSSZ3Z0ZNT8jwCGaCWeT4uW6HE4vWtbgHxbmhhazR2BVKdd
 Rdqg6kjyREIe4lAn_Pwwa3rsa.awMmVYNpI7_776N00.Udc7z_gABbQw6FawGxrF.EnbuKZy_D9N
 HWnvim9YaEbq.NcXz0sOSzW2GjkaD1byXtIpEOe9D6dyFkz_mpd_XWllKPt4UT62z8kUsoEDkWmF
 xdRgbmrvT7CPJvKFjp4_5dD12gERUYnCxCZc.z2JuAijYxJErCtaua_71JNY51WQsj8SuOvyzWG6
 b1UUHbb_GUWmvE_jqjkikVn763SH4o8mhH8qih4bTDcAhhUsPTkTBMPClz3P4ZB8fsomnZ1wc4Gr
 e1SNWgrh810u4ncP_nVWyzgO2i8TT6mwJ55ATQqsi5O4XBUAn5fZukPKkikUd2KcHMJ6vKD3kEQt
 ZKbQW3qBkIdq0LaSDpRRRRbv9ybuHN9B5u4I_qJtVpok9OeW63tU0JWgTq14wK7L9T.5AGYIbZsY
 WvvSso1m6GpAiMDCtzz93NLkmqIDioOzBFV6lo9cznARE5Hw9mnWKuHcg4xBXm5mSZqqSQ2mA8dA
 pncjrWaCxI2b1Am7jkV4XY3i_Ql_gHuG2v1UgbUcGEcoHPsRDrACz23ZaHG5h_ZGxOzZPwa0AXYH
 nM2oRWDMw4tD7PjzYMhXmaNfaFxGhSkdz2sQdDfXgwFLj0tMyRN2IDzyZx1bH0GbMcZ_NGOBrxEs
 2qjj1vRJe3pQ2TWd8n.gfWpHEQP_FyF8os3COF6XudYreO3CZjJCGoMKiQAr9e38I2nmYzEbM8ar
 QRL2RHoFMdkTqadF0U6ERhxPLN2aTK5O02gDpu561irJLacEdkVv2utxijerGLWpve9d6hc2Qhr.
 TX55jPWdZmQ9d
Received: from sonic.gate.mail.ne1.yahoo.com by sonic314.consmr.mail.bf2.yahoo.com with HTTP; Sat, 29 Aug 2020 17:08:59 +0000
Date:   Sat, 29 Aug 2020 17:08:55 +0000 (UTC)
From:   Sergeant Emad Alabbasi <mrschantal.sonian.kadi@gmail.com>
Reply-To: sergeantemad.alabbasi@gmail.com
Message-ID: <1258742841.157202.1598720935644@mail.yahoo.com>
Subject: Hello,
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
References: <1258742841.157202.1598720935644.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.16565 YMailNodin Mozilla/5.0 (Windows NT 6.1; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/84.0.4147.135 Safari/537.36
To:     unlisted-recipients:; (no To-header on input)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello,
 Hope I can trust you with the huge money I recently shared with my colleague during our peace keeping mission recently in an Oil reach area in Lybia.

The sum of 18.5 USD is my share and already with the company that will bring it to you for us to share 50% for you and mine 50%. 
Kindly reply for me to tell you everything directly [sergeantemad.alabbasi@gmail.com]

Thanks,
Sergeant Emad Alabbasi
