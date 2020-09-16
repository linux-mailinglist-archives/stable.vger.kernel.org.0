Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C3B326CB5C
	for <lists+stable@lfdr.de>; Wed, 16 Sep 2020 22:26:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727116AbgIPU0Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Sep 2020 16:26:24 -0400
Received: from sonic306-20.consmr.mail.ir2.yahoo.com ([77.238.176.206]:41546
        "EHLO sonic306-20.consmr.mail.ir2.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728328AbgIPU0S (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Sep 2020 16:26:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1600287977; bh=oAHe6u9CsElfpac+1FESIJPSQWIHqlBccsEXU92TOQE=; h=Date:From:Reply-To:Subject:References:From:Subject; b=hjRZ6fZ2nL05jw+QNIohND4DW7+6Tbx2kWo979qJ/G0sbV2NhWmZQjxYdnzuZ7TO92Td9/SL1mIJk0/KQtFssngZAuLJrmbm732OSoy6QsnAGq7trFy6KfjH5T9PDiFRR1nXb2pi5yu616G+VwYteyU3nyCKfb7SuFvGDqp9PF+L+1RzWbD8m5wnQozrXwYTe4rLUetNgNuzKfbmMZyq3Qm7+Ntr9gO8jTxXY3BEviBIzREdklJz98DleZvSjzLg2ohWnrRfwVzdp2v+c1T1Btsi1ewd4jUbJeccXZpm/oSJcqZ+fjBEdWakaSnQSrpHJm9wPA/KX2TVEnWFBQMVIg==
X-YMail-OSG: PB.3sqgVM1m.hPFa73ofpRJxsyI6sLDrocryKy4M4PWuIhX95nUModR8AYMX1vg
 QL5ZS2r9PJ6N3Y5gLUJ2SxBTljOsAAKwUaFhNxhVj75.usnHJjaUOokyfxhjRwp3aFTnafEEX0Ua
 NIvyY8cJoycFWn0BlMFAqqwyuC.cB7d.g7vj7YjmpXVUFA7CUVQuk3OuD4H1rkxP3OMtHyMHXaUq
 fHfxf.L993GdoQJNos0T4c3iPcBRrCCXg29hl8Pb8vrMq8F7D.UICCD0Y51hoUSBVsAwAHiwtfJr
 .HL2SPpffwGFMk.3CXraPhYHQoliqFzlUUhixGV1QrKXrlQQsaE0tz3svj18O5lOnpPOB4k6irV7
 4UAi0UJ7tMbUXNa541LVJhd8kwJDxLFYQwvxV3qpHZd.OXpLgPOgxryI.xBWliaEWU0JddKrVfM5
 FDWRxF58pMIlGPltHhh7yNo9rUIIa_wgYcyDjKHO5ps.rnqRbt707dB.Tt0zK7PrRDy3Lh0FzXkx
 4LvLPr0NX1_7xrYABKcV9.W5yXwR.VGLhVelz.xRbhKrD2e85Pctv4Sf5qeljVkD7HEVVkMxS_Jd
 9i4lbwTscWcDEVYT8tp6zyfBbrl2lnz1gcEzSF__7HTy7VwUazdHJWvm.ICdh2YadRpPKLU25a4i
 LCDpub5MmLwbMaZAN6YzF28k1UkzyZVitd.chWuIsonNNzwTclTghBMXtaKhbtiJ03VUGz4wu5PG
 _.zRfFFSnjONekfNpdJIUD8lg88VVQn8wh1AYH2kwlslQchtizZgIT_mdz06s4vl6c5rZDanw5mg
 vn8LCB27uyMXSCm3x25zx8bv1D5nZwoFVlN.D.RBZv4ydBN1e98YW997PzZPv7or7Py5zm8XFWMt
 AiZmqM02tCmFyU4tEQi8cSljjJ9n9QIYhM3M6UDXYOFfZy26Nz6Iwy5haALHz9TEdyIvDkNscxoZ
 HvFAsaDG55vuYlWDytE1cbjuwx4tZJNXP566K_r3cagSuS72oPMJMuyKu12io4KJ2AcdY7qk3PPg
 W3GO3h5MSkNOC8ZCjNqKLhgboNebxXAWVXCRhMdjFzEev7KiYhHAFrikX6yZH1O0fivVehG6u.GD
 FDDCt6qce2xR42jZ2WV_zNK_AQTFkIHfbQux9Cjea.Ssfdg.Cd5N3PduqvdiY_Z350cKS9X20kv1
 OV2js3C9DtLJQR6OoOgAftlnNNLpvHmO7RFGhF1YlJFL5ED.5smLZiTSpxFicaxDINAOsdb.RvXE
 6KtX4xcDsz._gWIJkS05Zq4GgelzXokudkKgoqEnWyMsG71T5rn4s.96g0eM6FwYLTXv95kueo0B
 pXnXBe05GO09jlvLRIhcIc3w9Nkh1L.fzTZ0jhW461D6LIwBL0c_axLHEIlIcUJJKUfctL5pQ437
 YLm7dtN44bEaExZ4lrd.yuDCbbQZ5YQp2hGR5evcwNCA05.LDoHK5mPd_SO9gStK3hQUqmUQzuqj
 AbEIWRA8e
Received: from sonic.gate.mail.ne1.yahoo.com by sonic306.consmr.mail.ir2.yahoo.com with HTTP; Wed, 16 Sep 2020 20:26:17 +0000
Date:   Wed, 16 Sep 2020 20:26:14 +0000 (UTC)
From:   Miss Linda <taniaallou53@gmail.com>
Reply-To: lindajonathan993@gmail.com
Message-ID: <1721052087.664364.1600287974338@mail.yahoo.com>
Subject: Hi my love
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
References: <1721052087.664364.1600287974338.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.16583 YMailNodin Mozilla/5.0 (Windows NT 6.1; rv:43.0) Gecko/20100101 Firefox/43.0
To:     unlisted-recipients:; (no To-header on input)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hey dear

Nice to meet you, Am Miss Linda I found your email here in google search and I picked 
interest to contact you. I've something very important which I would like
to discuss with you and I would appreciate if you respond back to me through my email address as to tell you more about me with my
photos, my private email as fellows??   lindajonathan993@gmail.com

From, Linda
