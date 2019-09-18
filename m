Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC31AB651A
	for <lists+stable@lfdr.de>; Wed, 18 Sep 2019 15:52:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727267AbfIRNwJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Sep 2019 09:52:09 -0400
Received: from serv1.kernkonzept.com ([159.69.200.6]:36249 "EHLO
        mx.kernkonzept.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726562AbfIRNwJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 Sep 2019 09:52:09 -0400
X-Greylist: delayed 2115 seconds by postgrey-1.27 at vger.kernel.org; Wed, 18 Sep 2019 09:52:08 EDT
Received: from p2e50e985.dip0.t-ipconnect.de ([46.80.233.133] helo=[192.168.2.106])
        by mx.kernkonzept.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128) (Exim 4.92)
        id 1iAZpE-0001qo-Bt; Wed, 18 Sep 2019 15:16:52 +0200
From:   Steffen Liebergeld <steffen.liebergeld@kernkonzept.com>
Subject: [PATCH v2] PCI: quirks: Fix register location for UPDCR
To:     linux-pci@vger.kernel.org
Cc:     Bjorn Helgaas <bhelgaas@google.com>, stable@vger.kernel.org
Openpgp: preference=signencrypt
Autocrypt: addr=steffen.liebergeld@kernkonzept.com; prefer-encrypt=mutual;
 keydata=
 mQINBFntthEBEADBWE33SiJZV+RF//mkWZ4XKilj3uknmNthRy+fS0JpsTZmBgTR3hGofwmk
 W1zdhtiLeZHFmuua/iVVXgyyE7dRlCx7SYdM/8LTITXp7B4DeRuRWgCkwKvpngCvckC14T+d
 APl8tEJn/DVe4jtonuFNVR2aYQ4otoJs/ctPa3xCW3sfdE3kauegBsLHagFiHSkxGgJGV9c0
 8BdKg4+Ret0+0m8c0cFWwWVHSK57HwjAJErUb5EL5EFyPAGAjYOTeQOZnWSGAbnKqtByFrSL
 caku5efdaTpu21X8DDsKfqW7qbGFvIe8dB5IoLtYpxcEDSnnwBX6ubztLyXATq/aYfE4LV2q
 TRMMBqDk7LFI5fmpLSAD+Fh7nTQJ1HHN8jfD8HHFjC8n3OmPLFiVfQpI9zGUhugZ/tVKIF1e
 aAWon7H1jh330gD0DCugqjP3j6e0md1s+PHh67xZm/9+C5swt+vxTaN0iqHk3fk3u6T5KZoM
 kdhIn0uvmCNESS0f0SDA6xwq5d3O0wjDx0CQzmut/xIP6RzclgG6eTvySZLhq0IrY9kK6jlt
 czkAGC5chWr3igBBhT8VI6ef2bS/+FqJHrZjPmXY5drxziLqKaYCv8N3XdKF8CQD4bnWC1n/
 fVo57J9n/ch+uEz6YYnFgS0agQcbdLJ9njG87fb5mzuAhxCGAwARAQABtDdTdGVmZmVuIExp
 ZWJlcmdlbGQgPHN0ZWZmZW4ubGllYmVyZ2VsZEBrZXJua29uemVwdC5jb20+iQJUBBMBCAA+
 AhsDBQkJZgGAAh4BAheAFiEEI9N34VEyhy+xxtSGRkeiY0Il+7IFAlytoUAFCwkIBwMFFQoJ
 CAsFFgIDAQAACgkQRkeiY0Il+7LPMBAAi9GhxP8Iwu4Io3kiuBsM+0SOrneq6zsu0ityhD3Z
 BxBaSSo0fEiKfQBWk/poFjZEAHY0AQaVP84LiNYTW3s0olYNThCgABY079V6Yaxfnf0/7OWW
 nbmSfJ+W43RWRq+CTw7Ws8rMlzStmXujZksDFq3SWclVqb9QXlY3zObkaVUp8d8sc/NQpRAe
 m1sasCjsTwiAtBragjPm1v4ODomUV/bkkwl6p4zCN5E4lBuD3+0YvmviYyiMzaA2cNWxFHvL
 hUe4y+HKmtSe172+3cCrU3gEhjScdkHZwr7ruIzlubJ+ZkU018wB4GkY/4QMSCbHj8ZXj6lx
 I1E81a6a0VMK1ZII2jLGEGdkhbf7LRPjqJx4HiALixxA5kT77iTnvuSzZl2HZdnbokl7s+F/
 mhaqN0XB//Scdd1yYZf9PGLGP+dJFvaBpt8p6v9/sfKX9uAs3XjlGJJ1wjG/IsFt8crXN8TO
 6AawXVKW8sPXQE0etPrxpEp3P2gsmgQdGZVHPm7NMzyJG6+itYcOOY307CgQ/23VBxZEbahn
 UOfhNLABftCEVSXI/WLvD3VaRTz/Q41SNcnRInQ551BKbiTrH0llwXx+FNb3FSHoSgXeSu5q
 LS7nd+Ju+UJFIbu9tatP8uHPZJXxxt06sV2jxsIwecTwL50F91i7etlgbNMj00d0MBy5Ag0E
 We22EQEQANJlyQtjWFrqmtx1tIUu8z0Bwd9YG+pK5WiBN9SlSVHGRnQU/GNVgvP2q7FExa/6
 LUnzMfQo4gNJioNI3ON1xK5KV6QkbH51ru6vowwYdM7rNzfTJ5GNGVX376UBUbvhSJPctgum
 JyRHBdWsAKdo3UdjMkDX8nLzWKJ4+p/oR8HV+bs0vjf6vebs+y7qD/2H7pXt4eXW7HMj+l9c
 EDJ0lCLuYY7RQS8CU95APTHpQYRXmIGP/k8ei+fa47ZQNh4wj9eCZmG/++gP/cH08UlyDVJx
 k3x3xc0m66l/VsO3i+jZ7yDDIWWIS0YGD+T2uoDyA8+6MPigrZ7Tb5Y/ydrkzDZ7CUcEuabu
 XqkaAEg3LXcyLXew96p2wA0jUJ/TUEI3zpg5wveDwcLDAwgKn+HcTHud7/SzV6TIFIRYu2I8
 Q1T55N0uMwvDHDjhxxmVxP3j2r21RP9N5ebGJgkHW1Lis+sEyClmTKyZ3tsKFa3+AggItY7o
 Dl/8exOTR6joFT9njvRcmKE6k+m2aiNBJQO9vTg/ehKUAmQScbx1Ee9yR8k/49uv7nhrXXin
 TtCKjlWwSEjZOx3LFfGxDcChvvxkpKEwMNoXQwnD7WI9fkg1ly8gdJgz99fS9QbNpGw1bh6N
 KJAA/2iHQ9FY0toACINHEdka9JdzIb/u5I8+Jjzm1AvLABEBAAGJAjwEGAEIACYWIQQj03fh
 UTKHL7HG1IZGR6JjQiX7sgUCWe22EQIbDAUJCWYBgAAKCRBGR6JjQiX7st/cD/9upEn+kMyu
 WslAJI9a2K+bNjngkVa+pddca6Bd8ETcilWOB0KxTPe+bbfpPwKJ+9pqngBZq21ziVf4Ve/G
 8Umsf+SflcQyeq54X1muU+dQOfZ7NrA6J4KRWmi9mr3KT04mMrKbjogEM2psMSz5l8UmXt7Z
 9U3PfEOyiQdmarceU+UNGt0g/EFPvdeAwdIvbymbZbg1dHCbl+JORcsu5WOaT6BQvopfJ5RG
 oMU1yTHPsPX7y9PonZRWGpsTWQcdN5kacR51JHqDMWFCtvt6yd+mPV5SIjmXWYVbhkj4f5aN
 PN/C7HxW4DBvjO3+cHzbJ0VhqgdaKi7vstG3TLc94eFHIstItQf4Yzn/sOJ9XvJo9KcrIDqk
 Xi1xXr1M883gB2b+NpbGW4vN1jIcEJYg6GH13nP4qrdb9JPFrOx4bVdZcGJ7/Kar1BTcuYpj
 P8riCz6A+Bxg9k6TW9rYTJ5FGowlo3TokVpWYCMK9RD9IyAzUmChrLgD5gcYgn6O+nuPOH7t
 PK0SdW0BmEfxTBB4nKxE62pLq15O/REplDgp9UEU3ubnkS0iAXN7rCcElW4X5LOmtNPL+SB4
 4DKtA0SPWtEiV7UXAzAYsRDJwe+1hHNBe5UYjfpEH8471qA36/Rtz1Z7HD/OGqD70a8/SsYj
 h2oJWECcMvUvwfrFRBCDM67cmQ==
Message-ID: <7a3505df-79ba-8a28-464c-88b83eefffa6@kernkonzept.com>
Date:   Wed, 18 Sep 2019 15:16:52 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

According to documentation [0] the correct offset for the
Upstream Peer Decode Configuration Register (UPDCR) is 0x1014.
It was previously defined as 0x1114.

Commit d99321b63b1f intends to enforce isolation between PCI
devices allowing them to be put into separate IOMMU groups.
Due to the wrong register offset the intended isolation was not
fully enforced. This is fixed with this patch.

Please note that I did not test this patch because I have
no hardware that implements this register.

[0]
https://www.intel.com/content/dam/www/public/us/en/documents/datasheets/4th-gen-core-family-mobile-i-o-datasheet.pdf
(page 325)

Fixes: d99321b63b1f ("PCI: Enable quirks for PCIe ACS on Intel PCH root ports")
Reviewed-by: Andrew Murray <andrew.murray@arm.com>
Signed-off-by: Steffen Liebergeld <steffen.liebergeld@kernkonzept.com>
---
 drivers/pci/quirks.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 208aacf39329..7e184beb2aa4 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -4602,7 +4602,7 @@ int pci_dev_specific_acs_enabled(struct pci_dev
*dev, u16 acs_flags)
 #define INTEL_BSPR_REG_BPPD  (1 << 9)
  /* Upstream Peer Decode Configuration Register */
-#define INTEL_UPDCR_REG 0x1114
+#define INTEL_UPDCR_REG 0x1014
 /* 5:0 Peer Decode Enable bits */
 #define INTEL_UPDCR_REG_MASK 0x3f
 -- 2.11.0


